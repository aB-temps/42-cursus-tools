# GENERAL SETTINGS ====================================================================
# NAME = <NAME OF YOUR PROGRAM>
LIB_NAME = lib_improved
.SILENT:

# DIRECTORIES==========================================================================
DIR_SRC		:= src/
DIR_INC 	:= include/
DIR_BUILD	:= .build/

DIR_LIB		:= $(LIB_NAME)/
DIR_INC_LIB	:= $(DIR_LIB)include/

# FLAGS & COMPILATOR SETTINGS =========================================================
CC 			:= cc
DEPS_FLAGS  := -MMD -MP
WARN_FLAGS	:= -Wall -Werror -Wextra
C_FLAGS		:= $(WARN_FLAGS) $(DEPS_FLAGS)
INC_FLAGS 	:= -I$(DIR_INC) -I$(DIR_INC_LIB)
LIB_FLAGS	:= -L$(DIR_LIB) -l_improved


COMP 		:= $(CC) $(C_FLAGS) $(INC_FLAGS)
LINK		:= $(LIB_FLAGS)

ANTI_RELINK	:= Makefile $(DIR_INC) $(DIR_INC_LIB) 

# FUNCTIONS ===========================================================================
define generate_var_sources_dir
DIR_$(1) = $(addprefix $(DIR_SRC), $(shell echo $(1) | tr '[:upper:]' '[:lower:]')/)
endef

define generate_var_sources
SRC_$(1) = $(addprefix $(DIR_$(1)),$(F_$(1)))
endef

define generate_var_objects
OBJS_$(1) = $(patsubst $(DIR_SRC)%.c,$(DIR_BUILD)%.o,$(SRC_$(1)))
endef

define generate_var_deps
DEPS_$(1) = $(patsubst $(DIR_SRC)%.c,$(DIR_BUILD)%.d,$(SRC_$(1)))
endef

# COMPONENTS ==========================================================================
# COMPONENTS :=	XXXXXXX\

# FILES ===============================================================================
F_MAIN :=		main.c

# VARS GENERATION =====================================================================
$(foreach comp,$(COMPONENTS),$(eval $(call generate_var_sources_dir,$(comp))))
$(foreach comp,$(COMPONENTS),$(eval $(call generate_var_sources,$(comp))))
$(foreach comp,$(COMPONENTS),$(eval $(call generate_var_objects,$(comp))))
$(foreach comp,$(COMPONENTS),$(eval $(call generate_var_deps,$(comp))))

OBJS := $(foreach comp, $(COMPONENTS), $(OBJS_$(comp))) \
		$(DIR_BUILD)main.o

DEPS := $(foreach comp, $(COMPONENTS), $(DEPS_$(comp))) \
		$(DIR_BUILD)main.d

# COMPILATION =========================================================================
$(NAME) : $(OBJS)
	$(COMP) $^ -o $@ $(LINK)
	@echo ✨ $(NAME) compiled ✨

$(DIR_BUILD) :
	@mkdir -p $(DIR_BUILD)

$(DIR_BUILD)%.o : $(DIR_SRC)%.c $(ANTI_RELINK) | $(DIR_BUILD)
	@mkdir -p $(dir $@)
	$(COMP) -c $< -o $@


-include $(DEPS)

# RULES ===============================================================================
# build -------------------------------------------------------------------------------
all : lib $(NAME)

lib :
	@make -s -C $(DIR_LIB)

# clean -------------------------------------------------------------------------------
clean:
	@make -s clean -C $(DIR_LIB)
	@rm -rf $(DIR_BUILD)

fclean: clean
	@make -s fclean -C $(DIR_LIB)
	@rm -f $(NAME)
	
re: fclean all

.DEFAULT_GOAL = all

# debug -------------------------------------------------------------------------------
print-%:
	@echo $($(patsubst print-%,%,$@))

.PHONY: all lib clean fclean re print-%