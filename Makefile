# -*- mode: Makefile; fill-column: 80; comment-column: 75; -*-

ERL = $(shell which erl)

ERLFLAGS= -pa $(CURDIR)/.eunit -pa $(CURDIR)/ebin -pa $(CURDIR)/*/ebin

REBAR=./rebar

JELAM_PLT=$(CURDIR)/.depsolver_plt

.PHONY: dialyzer typer clean distclean

compile:
	@./rebar get-deps compile

rel: compile
	@./relx

$(JELAM_PLT):
	dialyzer --output_plt $(JELAM_PLT) --build_plt \
		--apps erts kernel stdlib crypto public_key -r deps --fullpath

dialyzer: $(JELAM_PLT)
	dialyzer --plt $(JELAM_PLT) -pa deps/* --src src

typer: $(JELAM_PLT)
	typer --plt $(JELAM_PLT) -r ./src

clean:
	$(REBAR) clean

distclean: clean
	rm $(JELAM_PLT)
	rm -rvf $(CURDIR)/deps/*
