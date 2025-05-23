describe('Acceptance Test', function() {
  // REGULAR ROUTE

  it('Can visit the users page', function() {
    cy.visit('http://localhost:8000/users')
  })

  it('Can hide the names column', function() {
    cy.contains('Bob')
    cy.get('[phx-value-column=name]').first().click()
    cy.contains('Bob').should('not.exist')
  })

  it('Can show the names column again', function() {
    cy.contains('Bob').should('not.exist');
    cy.contains('Show Name').should('not.exist')
    cy.contains('Show Field Buttons').first().click()
    cy.contains('Show Name').first().click()
    cy.contains('Bob')
  })

  it('Can visit page 2', function() {
    cy.contains('Bob')
    cy.contains('Sioban').should('not.exist')
    cy.get('nav.exz-pagination-nav').contains('2').first().click()
    cy.contains('Sioban')
    cy.contains('Bob').should('not.exist')
  })

  it('Can search for names', function() {
    cy.visit('http://localhost:8000/users')
    cy.contains('Sioban').should('not.exist')
    cy.get('input#search_search').type('siob')
    cy.contains('Sioban')
    cy.contains('21')
    cy.contains('Bob').should('not.exist');
    cy.get('input#search_search').clear()
    cy.contains('Bob')
  })

  // LIVE SESSION

  it('Live Session: Can visit the users page', function() {
    cy.visit('http://localhost:8000/live_session_users')
  })

  it('Live Session: Can hide the names column', function() {
    cy.contains('Bob')
    cy.get('[phx-value-column=name]').first().click()
    cy.contains('Bob').should('not.exist')
  })

  it('Live Session: Can show the names column again', function() {
    cy.contains('Bob').should('not.exist');
    cy.contains('Show Name').should('not.exist')
    cy.contains('Show Field Buttons').first().click()
    cy.contains('Show Name').first().click()
    cy.contains('Bob')
  })

  it('Live Session: Can visit page 2', function() {
    cy.contains('Bob')
    cy.contains('Sioban').should('not.exist')
    cy.get('nav.exz-pagination-nav').contains('2').first().click()
    cy.contains('Sioban')
    cy.contains('Bob').should('not.exist')
  })

  // MISC

  it('Doesnt see the action column when there are no action buttons', function() {
    cy.visit('http://localhost:8000/posts/no_action_buttons')
    cy.contains('Posts')
    cy.contains('Show Field Buttons')
    cy.contains('Actions').should('not.exist')
  })

  it('Cannot see hide functionality when it is disabled', function() {
    cy.visit('http://localhost:8000/posts/disable_hide')
    cy.contains('Posts')
    cy.contains('Actions')
    cy.contains('Next')
    cy.contains('Show Field Buttons').should('not.exist')
    cy.contains('Hide').should('not.exist')
  })

  it('Cannot see pagination when it is disabled', function() {
    cy.visit('http://localhost:8000/posts/no_pagination')
    cy.contains('Posts')
    cy.contains('Actions')
    cy.contains('Show Field Buttons')
    cy.contains('Nex').should('not.exist')
  })

  it('Can use custom formatter', function() {
    cy.visit('http://localhost:8000/users/formatted')
    cy.contains('<<< Bob >>>')
    cy.contains('!!!boB!!!')
  })

  it('Can use custom text', function() {
    cy.visit('http://localhost:8000/beitrage')
    cy.contains('Beiträge auflisten')
    cy.contains('Ausblenden')
    cy.contains('Sortieren')
    cy.contains('Nächster')
    cy.contains('Bearbeiten')
    cy.contains('Löschen')
    cy.contains('Aktionen')
  })

  it('Can search across multiple columns', function() {
    cy.get('input#search_search').type('1 CONTENT')
    cy.contains('Post number 1')
    cy.contains('Post number 2').should('not.exist')
  })
})
