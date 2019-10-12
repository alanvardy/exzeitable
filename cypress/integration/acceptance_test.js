describe('Acceptance Test', function () {
  beforeEach(function () {
    // before each test, we can automatically preserve the
    // 'session_id' and 'remember_token' cookies. this means they
    // will not be cleared before the NEXT test starts.
    //
    // the name of your cookies will likely be different
    // this is just a simple example
    Cypress.Cookies.debug(true)
    Cypress.Cookies.preserveOnce('_tradesway_key')
  })

  it('Can visit the users page', function () {
    cy.visit('http://localhost:5000/users')
    cy.contains('SUCCESS')
  })

  it('Can hide the names column', function () {
    cy.contains('Bob')
    cy.get('[phx-value-column=name]').first().click()
    cy.contains('sdsdfa')
  })

  // it('Registers an account', function () {
  //   var email = 'test@test.com'
  //   var password = 'securepassword'

  //   cy.contains('Register').click()
  //   cy.get('input#user_email').type(email)
  //   cy.get('input#user_password').type(password)
  //   cy.get('input#user_confirm_password').type(password)
  //   cy.get('input#user_first_name').type("First")
  //   cy.get('input#user_last_name').type("Last")
  //   cy.get('input#user_mates_0_team_name').type("A-Team")
  //   cy.get('[type=submit]').click()
  // })

  // // it('Signs out and back in', function () {
  // //   var email = 'test@test.com'
  // //   var password = 'securepassword'

  // //   cy.contains('Sign out').click()
  // //   cy.visit('http://localhost:5000')

  // //   cy.contains('Sign in').click()
  // //   cy.get('input#user_email').type(email)
  // //   cy.get('input#user_password').type(password)
  // //   cy.get('[type=submit]').click()
  // //   cy.contains('Sign out')
  // // })

  // it('Can create sites', function () {
  //   var site_number = "234"
  //   var site_address = "1234 Reading Road"
  //   var site_city = "Edmonton"
  //   var site_country = "Canada"
  //   var site_name = "The Bestest Place"
  //   var site_postal_code = "T5E 9K1"
  //   var site_province = "Alberta"

  //   cy.contains('Sites').click()
  //   cy.contains('New').click()
  //   cy.get('input#site_number').type(site_number)
  //   cy.get('input#site_address').type(site_address)
  //   cy.get('input#site_city').type(site_city)
  //   cy.get('input#site_country').type(site_country)
  //   cy.get('input#site_name').type(site_name)
  //   cy.get('input#site_postal_code').type(site_postal_code)
  //   cy.get('input#site_province').type(site_province)
  //   cy.get('[type=submit]').click()
  //   cy.contains('Site created successfully')
  //   cy.contains(site_address)
  // })

  // it('Can create equipment', function () {
  //   var unit = "1223"
  //   var type = "Furnace"
  //   var client_designation = "123B"
  //   var location = "Over yonder"
  //   var make = "Trane"
  //   var model = "GTX4700"
  //   var serial = "asdfh789DJ3"
  //   var serves_area = "The room that noone uses"
  //   var site = "The Bestest Place"

  //   cy.contains('Equipment').click()
  //   cy.contains('New').click()
  //   cy.get('input#equipment_client_designation').type(client_designation)
  //   cy.get('input#equipment_location').type(location)
  //   cy.get('input#equipment_make').type(make)
  //   cy.get('input#equipment_model').type(model)
  //   cy.get('input#equipment_serial').type(serial)
  //   cy.get('input#equipment_serves_area').type(serves_area)
  //   cy.get('input#equipment_type').type(type)
  //   cy.get('input#equipment_unit').type(unit)
  //   cy.get('[type=submit]').click()
  //   cy.contains('Equipment created successfully')
  //   cy.contains(serves_area)

  //   // cy.contains('Sites').click()
  //   // cy.contains(site).parent('tr').contains('Show').click()
  //   // cy.contains('Equipment').click()
  //   // cy.contains(make)
  //   // cy.contains(model)
  // })

  // it('Can create contact', function () {
  //   var first_name = "Joe"
  //   var last_name = "Armstrong"
  //   var primary_number = "3920182738"
  //   var secondary_number = "1392839281"
  //   var role = "King Tuna"
  //   var email = "asdfkjhk@asdkfjh.com"
  //   var site = "The Bestest Place"

  //   cy.contains('Contacts').click()
  //   cy.contains('New').click()
  //   cy.get('input#contact_first_name').type(first_name)
  //   cy.get('input#contact_last_name').type(last_name)
  //   cy.get('input#contact_primary_number').type(primary_number)
  //   cy.get('input#contact_secondary_number').type(secondary_number)
  //   cy.get('input#contact_email').type(email)
  //   cy.get('input#contact_role').type(role)
  //   cy.get('select#contact_sites').select(site)
  //   cy.get('[type=submit]').click()
  //   cy.contains('Contact created successfully')
  // })

  // it('has linked the contact to the site', function () {
  //   var site = "The Bestest Place"

  //   cy.contains('Sites').click()
  //   cy.contains(site).parent('tr').contains('Show').click()
  //   cy.contains('Joe')
  //   cy.contains('Armstrong')
  // })
})
