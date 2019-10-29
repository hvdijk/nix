CXX_PATH = $(shell sh -c 'type -p $(CXX)')

$(buildprefix)%.o: %.cc
	@mkdir -p "$(dir $@)"
	$(trace-cpp) $(CXX) -o $@.ii -E $< $(GLOBAL_CXXFLAGS) $(GLOBAL_CXXFLAGS_PCH) $(CXXFLAGS) $($@_CXXFLAGS) -MMD -MF $(call filename-to-dep, $@) -MP
	$(trace-cxx) nix build -L --option experimental-features nix-command -o $@.link '(derivation { name = "cc"; system = "x86_64-linux"; builder = "/bin/sh"; args = [ "-c" "$${builtins.storePath $(CXX_PATH)} -std=c++17 -o $$out -c $${$@.ii} -g -Wall -fPIC -g -O3" ]; })'
	@rm -f $@
	@cp $@.link $@
	@rm -f $@.ii $@.link

$(buildprefix)%.o: %.cpp
	@mkdir -p "$(dir $@)"
	$(trace-cxx) $(CXX) -o $@ -c $< $(GLOBAL_CXXFLAGS) $(GLOBAL_CXXFLAGS_PCH) $(CXXFLAGS) $($@_CXXFLAGS) -MMD -MF $(call filename-to-dep, $@) -MP

$(buildprefix)%.o: %.c
	@mkdir -p "$(dir $@)"
	$(trace-cc) $(CC) -o $@ -c $< $(GLOBAL_CFLAGS) $(CFLAGS) $($@_CFLAGS) -MMD -MF $(call filename-to-dep, $@) -MP
