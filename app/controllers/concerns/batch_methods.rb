# frozen_string_literal: true

module BatchMethods
  extend ActiveSupport::Concern

  included do
    def update
      if params[:update_unless_empty]
        update_unless_empty
      elsif params[:update_and_add]
        update_and_add
      elsif params[:update_and_delete]
        update_and_delete
      else
        update_and_replace
      end
    end

    private

    def work_params
      WorksController.new.send(:reusable_work_params, params, current_user)
    end

    def update_unless_empty
      work_parameters = work_params.to_hash.select{|k,v| !(v == nil or v.to_s.strip.empty?)}
      if @works.update(work_parameters)
        redirect_to collection_works_path(@collection), notice: "De geselecteerde werken zijn bijgewerkt"
      else
        render :edit
      end
    end

    def update_and_add
      save_results = []
      @works.each do |work|
        combined_work_parameters = {}
        work_params.each do | parameter, values |
          if values.is_a? Array and parameter.to_s.match(/_ids$/)
            new_values = (work.send(parameter.gsub(/_ids$/,"s").to_sym).collect{|a| a.id} + values).uniq
            combined_work_parameters[parameter] = new_values
          else
            new_values = (work.send(parameter.to_sym).to_a + values).uniq
            combined_work_parameters[parameter] = new_values
          end
        end
        save_results << work.update(combined_work_parameters)
      end
      if !save_results.include?(false)
        redirect_to collection_works_path(@collection), notice: "De geselecteerde werken zijn bijgewerkt"
      else
        render :edit
      end
    end

    def update_and_delete
      save_results = []
      @works.each do |work|
        combined_work_parameters = {}
        work_params.each do | parameter, values |
          if values.is_a? Array and parameter.to_s.match(/_ids$/)
            new_values = (work.send(parameter.gsub(/_ids$/,"s").to_sym).collect{|a| a.id} - values).uniq
            combined_work_parameters[parameter] = new_values
          else
            new_values = (work.send(parameter.to_sym).to_a - values).uniq
            combined_work_parameters[parameter] = new_values
          end
        end
        save_results << work.update(combined_work_parameters)
      end
      if !save_results.include?(false)
        redirect_to collection_works_path(@collection), notice: "De geselecteerde werken zijn bijgewerkt"
      else
        render :edit
      end
    end

    def update_and_replace
      works_updated = @works.update(work_params)
      if works_updated.collect(&:valid?).include?(false)
        example_messages = works_updated.select{|w| !w.valid?}.collect{|w| "Werk #{w.stock_number} (id: #{w.id}): #{w.errors.messages[:base].to_sentence}"}.join("; ")
        @error_message = "Er zijn fouten opgetreden. #{example_messages}"
        edit

        render :edit

      elsif !works_updated.collect(&:valid?).include?(false)
        redirect_to collection_works_path(@collection), notice: "De geselecteerde werken zijn bijgewerkt"
      end
    end

  end

end
