require 'spec_helper'

describe 'Viewing posts', local: true do
  context 'on flow' do
    let!(:posts) { 30.times.map { create(:post) } }
    before { visit all_path }
  
    context 'as unauthorized user', js: true do
      it 'should show Post title' do
        page.find('section.posts > header').should have_content('Posts')
      end
      
      it 'should show 20 posts on page' do
        Post.page(nil).each do |post|
          page.should have_css('article.post h1', text: post.title)
        end
      end
      
      it 'should be able to view post' do
        page.find('article.post').find_link('Show').click
        page.should have_css('article.post.detail')
      end
      
      include_examples 'inactive buttons'
    end
  end
  
  context 'on detail' do
    let(:post) { create(:post) }
    before { visit post_path(post) }
    
    it 'should show Post title' do
      page.should_not have_css('header.title h1')
      page.find('article.post header h1').should have_content(post.title)
    end
    
    context 'as unauthorized user', js: true do
      include_examples 'inactive buttons'
    end
  end
end
