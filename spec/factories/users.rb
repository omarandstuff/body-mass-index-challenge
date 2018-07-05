FactoryGirl.define  do
  factory :david, class: User do
    email { 'david.deanda@tangosource.com' }
    firstname { 'David' }
    lastname { 'De Anda' }
    password { 'supersecret' }
  end

  factory :omar, class: User do
    email { 'omar.deanda@tangosource.com' }
    firstname { 'Omar' }
    lastname { 'De Anda' }
    password { 'supersecret' }
  end
end
