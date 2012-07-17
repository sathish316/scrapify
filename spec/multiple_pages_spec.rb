require 'spec_helper'
require 'test_models'

describe Scrapify do

  before do
    page1 = "http://www.magazines.com/pages/1"
    FakeWeb.register_uri :get, page1,
                         :body => <<-HTML
      <ul>
        <li>
          <div class="issue">i1</div><div class="title">title1</div>
          <div class="issue">i2</div><div class="title">title2</div>
          <div class="issue">i3</div><div class="title">title3</div>
        </li>
      </ul>
    HTML
    page2 = "http://www.magazines.com/pages/2"
    FakeWeb.register_uri :get, page2,
                         :body => <<-HTML
      <ul>
        <li>
          <div class="issue">i4</div><div class="title">title4</div>
          <div class="issue">i5</div><div class="title">title5</div>
          <div class="issue">i6</div><div class="title">title6</div>
        </li>
      </ul>
    HTML
    page3 = "http://www.magazines.com/pages/3"
    FakeWeb.register_uri :get, page3,
                         :body => <<-HTML
      <ul>
        <li>
          <div class="issue">i7</div><div class="title">title7</div>
          <div class="issue">i8</div><div class="title">title8</div>
          <div class="issue">i9</div><div class="title">title9</div>
        </li>
      </ul>
    HTML
  end

  it "should crawl and fetch data from multiple pages" do
    Magazine.all.to_json.should == [
      {issue: 'i1', title: 'title1'},
      {issue: 'i2', title: 'title2'},
      {issue: 'i3', title: 'title3'},
      {issue: 'i4', title: 'title4'},
      {issue: 'i5', title: 'title5'},
      {issue: 'i6', title: 'title6'},
      {issue: 'i7', title: 'title7'},
      {issue: 'i8', title: 'title8'},
      {issue: 'i9', title: 'title9'}
    ].to_json
  end
end