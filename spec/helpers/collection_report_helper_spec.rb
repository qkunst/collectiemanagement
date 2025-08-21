# frozen_string_literal: true

require "rails_helper"

# Specs in this file have access to a helper object that includes
# the TagsHelper. For example:
#
# describe TagsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe CollectionReportHelper, type: :helper do
  include Devise::Test::ControllerHelpers

  describe "#filter_check_box" do
    before do
      allow(helper).to receive(:show_filter_check_boxes).and_return(true)
    end
    it "renders a checkbox for location" do
      filter_params = {"filter[location_raw][]" => "asdf", "filter[location_floor_raw][]" => "verd", "filter[location_detail_raw][]" => "loc"}
      expect(helper.filter_check_box(filter_params)).to eq("<input type=\"checkbox\" name=\"filter[location_detail_raw][]\" id=\"filter_location_detail_raw_\" value=\"loc\" data-parent=\"{&quot;filter[location_floor_raw][]&quot;:&quot;verd&quot;}\" />")
    end
    it "renders a checkbox for an missing value" do
      filter_params = {"filter[cluster_id][]" => Work::Search::NOT_SET_VALUE}
      expect(helper.filter_check_box(filter_params)).to eq("<input type=\"checkbox\" name=\"filter[cluster_id][]\" id=\"filter_cluster_id_\" value=\"not_set\" data-parent=\"{}\" />")
    end
  end

  describe "#render_report_column" do
    before(:each) do
      @collection = collections(:collection1)

      allow(helper).to receive(:report).and_return(
        {
          object_format_code: {"m" => {count: 1083, subs: {}}, "l" => {count: 553, subs: {}}, "s" => {count: 357, subs: {}}, "xl" => {count: 211, subs: {}}, "xs" => {count: 132, subs: {}}, :missing => {count: 71, subs: {}}},
          frame_damage_types: {},
          condition_work: {{1 => "Goed (++)"} => {count: 2265, subs: {}}, {4 => "Slecht (--)"} => {count: 83, subs: {}}, {3 => "Matig (-)"} => {count: 38, subs: {}}, {2 => "Redelijk/Voldoende (+)"} => {count: 2, subs: {}}, :missing => {count: 19, subs: {}}},
          object_creation_year: {:missing => {count: 993, subs: {}}, [2002] => {count: 109, subs: {}}},
          object_categories_split: {{4 => "Grafiek"} => {count: 1144, subs: {techniques: {:missing => {count: 20, subs: {}}, {33 => "Zeefdruk"} => {count: 454, subs: {}}, {7 => "Ets"} => {count: 278, subs: {}}, {17 => "Lithografie"} => {count: 169, subs: {}}, {13 => "Houtsnede"} => {count: 126, subs: {}}, {16 => "Linoleumsnede"} => {count: 44, subs: {}}, {35 => "Handgekleurd"} => {count: 41, subs: {}}, {45 => "Gravure"} => {count: 26, subs: {}}, {9 => "Droge naald"} => {count: 16, subs: {}}, {91 => "Hoogdruk"} => {count: 12, subs: {}}, {158 => "Fosforprent"} => {count: 9, subs: {}}, {92 => "Diepdruk"} => {count: 8, subs: {}}, {137 => "Monotype"} => {count: 4, subs: {}}, {12 => "Gemengde techniek"} => {count: 3, subs: {}}, {162 => "Reproductie"} => {count: 3, subs: {}}, {172 => "Sjabloondruk"} => {count: 3, subs: {}}, {4 => "Blinddruk"} => {count: 1, subs: {}}, {72 => "Giclée"} => {count: 1, subs: {}}}}}},
          market_value: {missing: {count: 2407, subs: {}}},
          location_raw: {
            "Location A" => {
              count: 1527, subs: {location_floor_raw: {"Floor 1" => {count: 12, subs: {location_detail_raw: {missing: {count: 12, subs: {}}}}},
                                                       "Floor 2" => {count: 429, subs: {
                                                         location_detail_raw: {
                                                           "Detail I" => {count: 61, subs: {}}, "Detail II" => {count: 57, subs: {}}, :missing => {count: 55, subs: {}}
                                                         }
                                                       }}}}
            }
          },
          style: {}, subset: {},
          market_value_range: {[50] => {count: 2, subs: {market_value_max: {[100] => {count: 1, subs: {}}, [250] => {count: 1, subs: {}}}}}, [75] => {count: 2, subs: {market_value_max: {[100] => {count: 1, subs: {}}, [250] => {count: 1, subs: {}}}}}, :missing => {count: 3, subs: {}}},
          replacement_value_range: {[50] => {count: 1, subs: {market_value_max: {[100] => {count: 1, subs: {}}}}}, :missing => {count: 3, subs: {}}}

        }
      )
      allow(helper).to receive(:show_filter_check_boxes).and_return(true)
    end

    it "should render a empt report when no values are given" do
      expect(helper.render_report_column([:frame_damage_types])).to eq("")
    end
    it "should render location tree" do
      expect(helper.render_report_column([:location_raw])).to eq('<table><thead><tr class="section location_raw span-6"><th colspan="6">Adres en/of gebouw(deel)</th><th class="number" aria-sort="descending">#</th></tr>
</thead>
<tr class="content span-6 " data-group="d751713988987e9331980363e24189ce"><td colspan="6"><input type="checkbox" name="filter[location_raw][]" id="filter_location_raw_" value="Location A" data-parent="{}" /><a href="/collections/200799059/works?filter%5Blocation_raw%5D%5B%5D=Location+A">Location A</a></td><td class="count number">1527</td></tr>
<tr class="section location_floor_raw span-5"><td class="spacer"></td><th colspan="5">Verdieping</th><th class="number" aria-sort="descending">#</th></tr>
<tr class="content span-5 " data-group="2eb3aa0082c40f073f954889c8119b39"><td class="spacer"></td><td colspan="5"><input type="checkbox" name="filter[location_floor_raw][]" id="filter_location_floor_raw_" value="Floor 2" data-parent="{&quot;filter[location_raw][]&quot;:&quot;Location A&quot;}" /><a href="/collections/200799059/works?filter%5Blocation_floor_raw%5D%5B%5D=Floor+2&amp;filter%5Blocation_raw%5D%5B%5D=Location+A">Floor 2</a></td><td class="count number">429</td></tr>
<tr class="section location_detail_raw span-4"><td class="spacer"></td><td class="spacer"></td><th colspan="4">Locatie specificatie</th><th class="number" aria-sort="descending">#</th></tr>
<tr class="content span-4 " data-group="631a8f425ca79a8dc2fd71c18a2656b9"><td class="spacer"></td><td class="spacer"></td><td colspan="4"><input type="checkbox" name="filter[location_detail_raw][]" id="filter_location_detail_raw_" value="Detail I" data-parent="{&quot;filter[location_floor_raw][]&quot;:&quot;Floor 2&quot;}" /><a href="/collections/200799059/works?filter%5Blocation_detail_raw%5D%5B%5D=Detail+I&amp;filter%5Blocation_floor_raw%5D%5B%5D=Floor+2&amp;filter%5Blocation_raw%5D%5B%5D=Location+A">Detail I</a></td><td class="count number">61</td></tr>
<tr class="content span-4 " data-group="631a8f425ca79a8dc2fd71c18a2656b9"><td class="spacer"></td><td class="spacer"></td><td colspan="4"><input type="checkbox" name="filter[location_detail_raw][]" id="filter_location_detail_raw_" value="Detail II" data-parent="{&quot;filter[location_floor_raw][]&quot;:&quot;Floor 2&quot;}" /><a href="/collections/200799059/works?filter%5Blocation_detail_raw%5D%5B%5D=Detail+II&amp;filter%5Blocation_floor_raw%5D%5B%5D=Floor+2&amp;filter%5Blocation_raw%5D%5B%5D=Location+A">Detail II</a></td><td class="count number">57</td></tr>
<tr class="content span-4 " data-group="631a8f425ca79a8dc2fd71c18a2656b9"><td class="spacer"></td><td class="spacer"></td><td colspan="4"><input type="checkbox" name="filter[location_detail_raw][]" id="filter_location_detail_raw_" value="not_set" data-parent="{&quot;filter[location_floor_raw][]&quot;:&quot;Floor 2&quot;}" /><a href="/collections/200799059/works?filter%5Blocation_detail_raw%5D%5B%5D=not_set&amp;filter%5Blocation_floor_raw%5D%5B%5D=Floor+2&amp;filter%5Blocation_raw%5D%5B%5D=Location+A">Locatie specificatie onbekend</a></td><td class="count number">55</td></tr>
<tr class="group_separator"><td colspan="7"></td></tr>
<tr class="content span-5 " data-group="2eb3aa0082c40f073f954889c8119b39"><td class="spacer"></td><td colspan="5"><input type="checkbox" name="filter[location_floor_raw][]" id="filter_location_floor_raw_" value="Floor 1" data-parent="{&quot;filter[location_raw][]&quot;:&quot;Location A&quot;}" /><a href="/collections/200799059/works?filter%5Blocation_floor_raw%5D%5B%5D=Floor+1&amp;filter%5Blocation_raw%5D%5B%5D=Location+A">Floor 1</a></td><td class="count number">12</td></tr>
<tr class="section location_detail_raw span-4"><td class="spacer"></td><td class="spacer"></td><th colspan="4">Locatie specificatie</th><th class="number" aria-sort="descending">#</th></tr>
<tr class="content span-4 " data-group="c54582b2b7284f04a5c25d4cf7e5a89c"><td class="spacer"></td><td class="spacer"></td><td colspan="4"><input type="checkbox" name="filter[location_detail_raw][]" id="filter_location_detail_raw_" value="not_set" data-parent="{&quot;filter[location_floor_raw][]&quot;:&quot;Floor 1&quot;}" /><a href="/collections/200799059/works?filter%5Blocation_detail_raw%5D%5B%5D=not_set&amp;filter%5Blocation_floor_raw%5D%5B%5D=Floor+1&amp;filter%5Blocation_raw%5D%5B%5D=Location+A">Locatie specificatie onbekend</a></td><td class="count number">12</td></tr>
<tr class="group_separator"><td colspan="7"></td></tr>
<tr class="group_separator"><td colspan="7"></td></tr>
<tr class="group_separator"><td colspan="7"></td></tr>
</table>')
    end
    it "should render a simple report (with missing)" do
      expect(helper.render_report_column([:condition_work])).to eq('<table class="sortable"><thead><tr class="section condition_work span-6"><th colspan="6">Conditie beeld</th><th class="number" aria-sort="descending">#</th></tr>
</thead>
<tr class="content span-6 " data-group="d751713988987e9331980363e24189ce"><td colspan="6"><input type="checkbox" name="filter[condition_work_id][]" id="filter_condition_work_id_" value="1" data-parent="{}" /><a href="/collections/200799059/works?filter%5Bcondition_work_id%5D%5B%5D=1">Goed (++)</a></td><td class="count number">2265</td></tr>
<tr class="content span-6 " data-group="d751713988987e9331980363e24189ce"><td colspan="6"><input type="checkbox" name="filter[condition_work_id][]" id="filter_condition_work_id_" value="4" data-parent="{}" /><a href="/collections/200799059/works?filter%5Bcondition_work_id%5D%5B%5D=4">Slecht (--)</a></td><td class="count number">83</td></tr>
<tr class="content span-6 " data-group="d751713988987e9331980363e24189ce"><td colspan="6"><input type="checkbox" name="filter[condition_work_id][]" id="filter_condition_work_id_" value="3" data-parent="{}" /><a href="/collections/200799059/works?filter%5Bcondition_work_id%5D%5B%5D=3">Matig (-)</a></td><td class="count number">38</td></tr>
<tr class="content span-6 " data-group="d751713988987e9331980363e24189ce"><td colspan="6"><input type="checkbox" name="filter[condition_work_id][]" id="filter_condition_work_id_" value="not_set" data-parent="{}" /><a href="/collections/200799059/works?filter%5Bcondition_work_id%5D%5B%5D=not_set">Niets ingevuld</a></td><td class="count number">19</td></tr>
<tr class="content span-6 " data-group="d751713988987e9331980363e24189ce"><td colspan="6"><input type="checkbox" name="filter[condition_work_id][]" id="filter_condition_work_id_" value="2" data-parent="{}" /><a href="/collections/200799059/works?filter%5Bcondition_work_id%5D%5B%5D=2">Redelijk/Voldoende (+)</a></td><td class="count number">2</td></tr>
<tr class="group_separator"><td colspan="7"></td></tr>
</table>')
    end
    it "should render a report with numbers" do
      expect(helper.render_report_column([:object_creation_year])).to eq('<table class="sortable"><thead><tr class="section object_creation_year span-6"><th colspan="6" aria-sort="ascending">Datering (jaar)</th><th class="number">#</th></tr>
</thead>
<tr class="content span-6 " data-group="d751713988987e9331980363e24189ce"><td colspan="6"><input type="checkbox" name="filter[object_creation_year][]" id="filter_object_creation_year_" value="2002" data-parent="{}" /><a href="/collections/200799059/works?filter%5Bobject_creation_year%5D%5B%5D=2002">2002</a></td><td class="count number">109</td></tr>
<tr class="content span-6 " data-group="d751713988987e9331980363e24189ce"><td colspan="6"><input type="checkbox" name="filter[object_creation_year][]" id="filter_object_creation_year_" value="not_set" data-parent="{}" /><a href="/collections/200799059/works?filter%5Bobject_creation_year%5D%5B%5D=not_set">Niets ingevuld</a></td><td class="count number">993</td></tr>
<tr class="group_separator"><td colspan="7"></td></tr>
</table>')
    end
    it "should render a report with a string/key" do
      expect(helper.render_report_column([:object_format_code])).to eq('<table class="sortable"><thead><tr class="section object_format_code span-6"><th colspan="6">Formaatcode</th><th class="number" aria-sort="descending">#</th></tr>
</thead>
<tr class="content span-6 " data-group="d751713988987e9331980363e24189ce"><td colspan="6"><input type="checkbox" name="filter[object_format_code][]" id="filter_object_format_code_" value="m" data-parent="{}" /><a href="/collections/200799059/works?filter%5Bobject_format_code%5D%5B%5D=m">M</a></td><td class="count number">1083</td></tr>
<tr class="content span-6 " data-group="d751713988987e9331980363e24189ce"><td colspan="6"><input type="checkbox" name="filter[object_format_code][]" id="filter_object_format_code_" value="l" data-parent="{}" /><a href="/collections/200799059/works?filter%5Bobject_format_code%5D%5B%5D=l">L</a></td><td class="count number">553</td></tr>
<tr class="content span-6 " data-group="d751713988987e9331980363e24189ce"><td colspan="6"><input type="checkbox" name="filter[object_format_code][]" id="filter_object_format_code_" value="s" data-parent="{}" /><a href="/collections/200799059/works?filter%5Bobject_format_code%5D%5B%5D=s">S</a></td><td class="count number">357</td></tr>
<tr class="content span-6 " data-group="d751713988987e9331980363e24189ce"><td colspan="6"><input type="checkbox" name="filter[object_format_code][]" id="filter_object_format_code_" value="xl" data-parent="{}" /><a href="/collections/200799059/works?filter%5Bobject_format_code%5D%5B%5D=xl">XL</a></td><td class="count number">211</td></tr>
<tr class="content span-6 " data-group="d751713988987e9331980363e24189ce"><td colspan="6"><input type="checkbox" name="filter[object_format_code][]" id="filter_object_format_code_" value="xs" data-parent="{}" /><a href="/collections/200799059/works?filter%5Bobject_format_code%5D%5B%5D=xs">XS</a></td><td class="count number">132</td></tr>
<tr class="content span-6 " data-group="d751713988987e9331980363e24189ce"><td colspan="6"><input type="checkbox" name="filter[object_format_code][]" id="filter_object_format_code_" value="not_set" data-parent="{}" /><a href="/collections/200799059/works?filter%5Bobject_format_code%5D%5B%5D=not_set">Formaatcode onbekend</a></td><td class="count number">71</td></tr>
<tr class="group_separator"><td colspan="7"></td></tr>
</table>')
    end
    it "should created the proper nested urls" do
      @object_categories_split_result = helper.render_report_column([:object_categories_split])

      ["/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4",
        "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=33",
        "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=7",
        "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=17",
        "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=13",
        "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=16",
        "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=35",
        "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=45",
        "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques%5D%5B%5D=not_set",
        "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=9",
        "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=91",
        "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=158",
        "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=92",
        "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=137",
        "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=162",
        "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=12",
        "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=172",
        "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=4",
        "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=72"].each do |link|
        @object_categories_split_result.match(link)
      end
    end
  end
  describe "#iterate_report_sections" do
    let(:can_do_advanced_filtering) { false }
    before(:each) do
      @collection = collections(:collection1)
      allow(helper).to receive(:report).and_return(
        {
          object_format_code: {"m" => {count: 1083, subs: {}}, "l" => {count: 553, subs: {}}, "s" => {count: 357, subs: {}}, "xl" => {count: 211, subs: {}}, "xs" => {count: 132, subs: {}}, :missing => {count: 71, subs: {}}},
          frame_damage_types: {}
        }
      )
    end

    def can? a, b
      can_do_advanced_filtering
    end
    it "should display a 7 column table; with a 6 col wide fields (header should span 6 cols) and 1 col count" do
      section = helper.report[:object_format_code]
      expect(iterate_report_sections("object_format_code", section, 6)).to eq("<thead><tr class=\"section object_format_code span-6\"><th colspan=\"6\">Formaatcode</th><th class=\"number\" aria-sort=\"descending\">#</th></tr>
</thead>
<tr class=\"content span-6 \" data-group=\"d751713988987e9331980363e24189ce\"><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bobject_format_code%5D%5B%5D=m\">M</a></td><td class=\"count number\">1083</td></tr>
<tr class=\"content span-6 \" data-group=\"d751713988987e9331980363e24189ce\"><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bobject_format_code%5D%5B%5D=l\">L</a></td><td class=\"count number\">553</td></tr>
<tr class=\"content span-6 \" data-group=\"d751713988987e9331980363e24189ce\"><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bobject_format_code%5D%5B%5D=s\">S</a></td><td class=\"count number\">357</td></tr>
<tr class=\"content span-6 \" data-group=\"d751713988987e9331980363e24189ce\"><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bobject_format_code%5D%5B%5D=xl\">XL</a></td><td class=\"count number\">211</td></tr>
<tr class=\"content span-6 \" data-group=\"d751713988987e9331980363e24189ce\"><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bobject_format_code%5D%5B%5D=xs\">XS</a></td><td class=\"count number\">132</td></tr>
<tr class=\"content span-6 \" data-group=\"d751713988987e9331980363e24189ce\"><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bobject_format_code%5D%5B%5D=not_set\">Formaatcode onbekend</a></td><td class=\"count number\">71</td></tr>
<tr class=\"group_separator\"><td colspan=\"7\"></td></tr>
")
    end

    context "can do advanced filtering" do
      let(:can_do_advanced_filtering) { true }

      # otherwise local path isn't available
      def t item
        item
      end
      it "should display a 7 column table; with a 6 col wide fields (header should span 6 cols) and 1 col count" do
        section = helper.report[:object_format_code]
        expect(iterate_report_sections("object_format_code", section, 6)).to start_with('<thead><tr class="section object_format_code span-6"><th colspan="6">Formaatcode <label class="inline right switch"><input type="checkbox" id="filter__invert_object_format_code" aria-label=".show_none"  name="filter[_invert][]" value="object_format_code" title=".filter_not_selected"/><span class="unchecked primary " aria-hidden="true">.include</span><span class="checked warning" aria-hidden="true">.exclude</span></label></th><th class="number" aria-sort="descending">#</th></tr>')
      end
    end
  end

  describe "#render_range" do
    before do
      allow(helper).to receive(:report).and_return({
        market_value_range: {[50] => {count: 2, subs: {market_value_max: {[100] => {count: 1, subs: {}}, [250] => {count: 1, subs: {}}}}}, [75] => {count: 2, subs: {market_value_max: {[100] => {count: 1, subs: {}}, [250] => {count: 1, subs: {}}}}}, :missing => {count: 3, subs: {}}},
        replacement_value_range: {[50] => {count: 1, subs: {replacement_value_max: {[100] => {count: 1, subs: {}}}}}, :missing => {count: 3, subs: {}}}
      })
    end
    it "works with simple example" do
      @collection = collections(:collection1)
      group = :replacement_value_range

      section = sort_contents_by_group(helper.report[group], group)

      expect(render_range(section, group)).to eq("<tfoot><tr><td class=\"count\" colspan=\"7\">Totaal: €50 - €100</td></tr></tfoot><tr><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Breplacement_value_max%5D%5B%5D=100&amp;filter%5Breplacement_value_min%5D%5B%5D=50\">€50 - €100</a></td><td class=\"count\">1</td></tr><tr><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Breplacement_value_max%5D%5B%5D=not_set\">Niets ingevuld</a></td><td class=\"count\">3</td></tr>")
    end

    it "works with complex example" do
      @collection = collections(:collection1)
      group = :market_value_range

      section = sort_contents_by_group(helper.report[group], group)

      expect(render_range(section, group)).to eql("<tfoot><tr><td class=\"count\" colspan=\"7\">Totaal: €250 - €700</td></tr></tfoot><tr><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bmarket_value_max%5D%5B%5D=100&amp;filter%5Bmarket_value_min%5D%5B%5D=75\">€75 - €100</a></td><td class=\"count\">1</td></tr><tr><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bmarket_value_max%5D%5B%5D=250&amp;filter%5Bmarket_value_min%5D%5B%5D=75\">€75 - €250</a></td><td class=\"count\">1</td></tr><tr><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bmarket_value_max%5D%5B%5D=100&amp;filter%5Bmarket_value_min%5D%5B%5D=50\">€50 - €100</a></td><td class=\"count\">1</td></tr><tr><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bmarket_value_max%5D%5B%5D=250&amp;filter%5Bmarket_value_min%5D%5B%5D=50\">€50 - €250</a></td><td class=\"count\">1</td></tr><tr><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bmarket_value_max%5D%5B%5D=not_set\">Niets ingevuld</a></td><td class=\"count\">3</td></tr>")
    end
  end
end
