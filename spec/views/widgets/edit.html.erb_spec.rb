require 'spec_helper'

describe "widgets/edit.html.erb" do
  before(:each) do
    @widget = assign(:widget, stub_model(Widget,
      :new_record? => false,
      :name => "MyString"
    ))
  end

  it "renders the edit widget form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => widget_path(@widget), :method => "post" do
      assert_select "input#widget_name", :name => "widget[name]"
    end
  end
end
