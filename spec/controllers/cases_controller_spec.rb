require 'spec_helper'

describe CasesController do

  describe "GET 'new'" do
    it "redirects to the login page" do
      get 'new'
      response.should be_redirect
    end
  end

end
