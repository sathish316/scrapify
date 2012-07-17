require 'spec_helper'
require 'test_models'

describe Scrapify do

  before do
    page1 = "http://www.books.com/pages/1"
    FakeWeb.register_uri :get, page1,
                         :body => <<-HTML
      <ul>
        <li>
          <div class="isbn">i1</div><div class="title">title1</div>
          <div class="isbn">i2</div><div class="title">title2</div>
          <div class="isbn">i3</div><div class="title">title3</div>
        </li>
      </ul>
      <a class="next_page" href="http://www.books.com/pages/2">Next</a>
    HTML
    page2 = "http://www.books.com/pages/2"
    FakeWeb.register_uri :get, page2,
                         :body => <<-HTML
      <ul>
        <li>
          <div class="isbn">i4</div><div class="title">title4</div>
          <div class="isbn">i5</div><div class="title">title5</div>
          <div class="isbn">i6</div><div class="title">title6</div>
        </li>
      </ul>
      <a class="next_page" href="http://www.books.com/pages/3">Next</a>
    HTML
    page3 = "http://www.books.com/pages/3"
    FakeWeb.register_uri :get, page3,
                         :body => <<-HTML
      <ul>
        <li>
          <div class="isbn">i7</div><div class="title">title7</div>
          <div class="isbn">i8</div><div class="title">title8</div>
          <div class="isbn">i9</div><div class="title">title9</div>
        </li>
      </ul>
    HTML
  end

  it "should crawl and fetch data using next page selector" do
    Book.all.to_json.should == [
      {isbn: 'i1', title: 'title1'},
      {isbn: 'i2', title: 'title2'},
      {isbn: 'i3', title: 'title3'},
      {isbn: 'i4', title: 'title4'},
      {isbn: 'i5', title: 'title5'},
      {isbn: 'i6', title: 'title6'},
      {isbn: 'i7', title: 'title7'},
      {isbn: 'i8', title: 'title8'},
      {isbn: 'i9', title: 'title9'}
    ].to_json
  end
end