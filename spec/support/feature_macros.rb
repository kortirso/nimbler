module FeatureMacros
    def sign_in(user)
        visit root_path
        click_on 'log'
        within '#login form#new_user' do
            fill_in 'user_username', with: user.username
            fill_in 'user_password', with: user.password

            click_button 'Login'
        end
        visit root_path
    end
end