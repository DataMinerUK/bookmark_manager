feature 'Creating links' do

  scenario 'I can create a new link' do
    visit '/links/new'
    fill_in 'url', with: 'http://www.zombo.com/'
    fill_in 'url', with: 'This is Zombocom'
    click_button 'Create link'

    # we expect to be redirected back to the links page
    expect(current_path).to eq '/links'

    within 'ul#links' do
      expect(page).to have_content('This is Zombocom')
    end
  end

  scenario 'there are no links in the database at the start of the test' do
    expect(Link.count).to eq 0
  end

end
