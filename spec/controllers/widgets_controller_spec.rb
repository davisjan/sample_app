require 'spec_helper'

describe WidgetsController do

  def mock_widget(stubs={})
    (@mock_widget ||= mock_model(Widget).as_null_object).tap do |widget|
      widget.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all widgets as @widgets" do
      Widget.stub(:all) { [mock_widget] }
      get :index
      assigns(:widgets).should eq([mock_widget])
    end
  end

  describe "GET show" do
    it "assigns the requested widget as @widget" do
      Widget.stub(:find).with("37") { mock_widget }
      get :show, :id => "37"
      assigns(:widget).should be(mock_widget)
    end
  end

  describe "GET new" do
    it "assigns a new widget as @widget" do
      Widget.stub(:new) { mock_widget }
      get :new
      assigns(:widget).should be(mock_widget)
    end
  end

  describe "GET edit" do
    it "assigns the requested widget as @widget" do
      Widget.stub(:find).with("37") { mock_widget }
      get :edit, :id => "37"
      assigns(:widget).should be(mock_widget)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created widget as @widget" do
        Widget.stub(:new).with({'these' => 'params'}) { mock_widget(:save => true) }
        post :create, :widget => {'these' => 'params'}
        assigns(:widget).should be(mock_widget)
      end

      it "redirects to the created widget" do
        Widget.stub(:new) { mock_widget(:save => true) }
        post :create, :widget => {}
        response.should redirect_to(widget_url(mock_widget))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved widget as @widget" do
        Widget.stub(:new).with({'these' => 'params'}) { mock_widget(:save => false) }
        post :create, :widget => {'these' => 'params'}
        assigns(:widget).should be(mock_widget)
      end

      it "re-renders the 'new' template" do
        Widget.stub(:new) { mock_widget(:save => false) }
        post :create, :widget => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested widget" do
        Widget.should_receive(:find).with("37") { mock_widget }
        mock_widget.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :widget => {'these' => 'params'}
      end

      it "assigns the requested widget as @widget" do
        Widget.stub(:find) { mock_widget(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:widget).should be(mock_widget)
      end

      it "redirects to the widget" do
        Widget.stub(:find) { mock_widget(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(widget_url(mock_widget))
      end
    end

    describe "with invalid params" do
      it "assigns the widget as @widget" do
        Widget.stub(:find) { mock_widget(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:widget).should be(mock_widget)
      end

      it "re-renders the 'edit' template" do
        Widget.stub(:find) { mock_widget(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested widget" do
      Widget.should_receive(:find).with("37") { mock_widget }
      mock_widget.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the widgets list" do
      Widget.stub(:find) { mock_widget }
      delete :destroy, :id => "1"
      response.should redirect_to(widgets_url)
    end
  end

end
