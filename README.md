# flutter_agc_mockup_3_f23

The main changes in this version are:

* The use of Riverpod for state management. The data model entities are now accessed using Providers.

* The ability to add and edit garden data using the Add Garden and Edit Garden pages.

* The ability to login as any defined user by entering their email. The password field is not checked, you can leave it blank. The signin page updates the currentUserID Riverpod provider with the email of the defined user for access by the rest of the app. If you enter an email that is not associated with a defined user, the UI will let you know and not let you proceed to the Home Page.
