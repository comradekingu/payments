# Architecture

### Authentication

This project does not handle any authentication. It simply accepts a JWT token
generated from another project to grant access to resources.

### Payments

Payment distributing happens in two steps. First, we take the payment token,
charge the source, and record the amount split to each account. The second step
goes through all of the splits connected to an account and transfers them.
