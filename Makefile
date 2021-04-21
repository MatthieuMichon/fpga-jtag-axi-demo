.PHONY: board-reconfigure
board-reconfigure:
	$(MAKE) $@ -C jam-demo-firmware/ MAKEFLAGS=

.PHONY: clean
clean:
	$(MAKE) $@ -C jam-demo-firmware/ MAKEFLAGS=
