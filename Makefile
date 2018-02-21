DOC_DRAFTBASE = draft-ietf-netmod-rfc6087bis
DOC_DRAFT = ${DOC_DRAFTBASE}-18
DOC_SRC = yang-usage.txt
DOC_BACK = yang-usage-back.xml
INCLUDES = ietf-template.yang

PYANG = pyang --ietf
YANG2DSDL = yang2dsdl

OUTLINE2XML = $(HOME)/swdev/yang-gang/bin/outline2xml
XML2RFC = $(HOME)/swdev/yang-gang/bin/xml2rfc.tcl

FONT_CHANGE = \
-e 's/background-color: \#CCC/background-color: \#FFF/' \
-e 's:<br */> *<hr */>::g' \
-e '/class="TOCbug"/d' \

DOC_O2XARGS = \
-n "${DOC_DRAFT}"

all: txt html

txt: $(DOC_DRAFT).txt

html: $(DOC_DRAFT).html

%.txt: %.xml
	@echo "Generating $@ ..."
	@$(XML2RFC) $< $@

%.html: %.xml
	@echo "Generating $@ ..."
	@${RFC2629XSLT}  $< > $@ || (rm $@ ; false)

%.ohtml: %.xml
	@echo "Generating $@ ..."
	@$(XML2RFC) $< $@
	@mv $@ $@~
	@sed ${FONT_CHANGE} < $@~ > $@
	@rm $@~

$(DOC_DRAFT).xml: ${DOC_SRC} ${DOC_BACK} ${INCLUDES}
	@echo "Generating $@ ..."
	@$(OUTLINE2XML) ${DOC_O2XARGS} $< > $@ || (rm $@ ; false)

$(DOC_DRAFT).fxml: ${DOC_SRC} ${DOC_BACK} ${INCLUDES}
	@echo "Generating $@ ..."
	@$(OUTLINE2XML) -D ${DOC_O2XARGS} $< > $@ || (rm $@ ; false)

RFC2629XSLT = xsltproc --path $(HOME)/swdev/yang-gang/bin $(HOME)/swdev/yang-gang/bin/rfc2629-yang.xslt

$(DOC_DRAFT).html: $(DOC_DRAFT).fxml
	${RFC2629XSLT}  $< > $@ || (rm $@ ; false)

validate:
	$(PYANG) $(INCLUDES)

clean:
	rm -f $(DOC_DRAFTBASE)-*.txt \
		$(DOC_DRAFTBASE)-*.xml \
		$(DOC_DRAFTBASE)-*.html \
		$(DOC_DRAFTBASE)-*.fxml
	rm -f *.rng *.dsrl *.sch
