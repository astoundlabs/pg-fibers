pg-fibers
=========

Very basic wrapper around pg library that fiberizes a few methods.  Currently, these are:

pg.connect
pg.connect.query

When called, both of these methods return their results immediately.  They are meant to be run within a fiber.