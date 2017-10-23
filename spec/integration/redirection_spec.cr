require "../spec_helper"

describe Crest do
  describe "Redirects handling" do
    it "should redirect" do
      response = Crest.get("#{TEST_SERVER_URL}/redirect")
      (response.status_code).should eq(200)
      (response.url).should eq("#{TEST_SERVER_URL}/")
      (response.body).should eq("Hello World!")
      (response.history.size).should eq(1)
      (response.history.first.url).should eq("#{TEST_SERVER_URL}/redirect")
      (response.history.first.status_code).should eq(302)
    end

    it "should raise error when too many redirects" do
      expect_raises Crest::RequestFailed, "HTTP status code 302" do
        Crest.get("#{TEST_SERVER_URL}/redirect/circle1")
      end
    end

    it "should not follow redirection when max_redirects is 0" do
      expect_raises Crest::RequestFailed, "HTTP status code 302" do
        response = Crest::Request.execute(method: :get, url: "#{TEST_SERVER_URL}/redirect", max_redirects: 0)
      end
    end
  end
end