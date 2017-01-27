class GenerateAppraisalsFromWorks < ActiveRecord::Migration[5.0]
  def change
    works = Work.where.not(price_reference: [nil,""]).or(Work.where.not(market_value:nil)).or(Work.where.not(replacement_value:nil)).or(Work.where.not(valuation_on:nil))
    # Appraisal(id: integer, appraised_on: date, market_value: float, replacement_value: float, appraised_by: string, user_id: integer, reference: text, created_at: datetime, updated_at: datetime, work_id: integer)

    works.all.each do |work|
      appraisal = work.appraisals.find_or_initialize_by({
        appraised_on: work.valuation_on,
        market_value: work.market_value,
        replacement_value: work.replacement_value,
        reference: work.price_reference
      })
      appraisal.save
    end
  end
end
