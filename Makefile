
.PHONY: board-reconfigure
board-reconfigure: ${BIT_FILE}
	$(MAKE) $@ -C jam-demo-firmware/ MAKEFLAGS=

.PHONY: clean
clean:
	$(MAKE) $@ -C jam-demo-firmware/ MAKEFLAGS=
