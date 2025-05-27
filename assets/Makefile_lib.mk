# GENERAL SETTINGS ====================================================================
# NAME = <NAME OF YOUR PROGRAM>
.SILENT:

# DIRECTORIES==========================================================================
DIR_SRC		:= sources/
DIR_INC 	:= includes/
DIR_BUILD	:= .build/

# FLAGS & COMPILATOR SETTINGS =========================================================
CC 			:= cc
DEPS_FLAGS  := -MMD -MP
WARN_FLAGS	:= -Wall -Werror -Wextra
C_FLAGS		:= $(WARN_FLAGS) $(DEPS_FLAGS)
INC_FLAG	:= -I$(DIR_INC)

COMP 		:= $(CC) $(C_FLAGS) $(INC_FLAG)

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
# F_XXXX :=		XXXX.c\

# VARS GENERATION =====================================================================
$(foreach comp,$(COMPONENTS),$(eval $(call generate_var_sources_dir,$(comp))))
$(foreach comp,$(COMPONENTS),$(eval $(call generate_var_sources,$(comp))))
$(foreach comp,$(COMPONENTS),$(eval $(call generate_var_objects,$(comp))))
$(foreach comp,$(COMPONENTS),$(eval $(call generate_var_deps,$(comp))))

OBJS := $(foreach comp, $(COMPONENTS), $(OBJS_$(comp)))

DEPS := $(foreach comp, $(COMPONENTS), $(DEPS_$(comp)))

# COMPILATION =========================================================================
$(NAME) : $(OBJS)
	ar rcs $@ $^
	@echo ✨ $(NAME) compiled ✨

$(DIR_BUILD) :
	@mkdir -p $(DIR_BUILD)

$(DIR_BUILD)%.o : $(DIR_SRC)%.c $(ANTI_RELINK) | $(DIR_BUILD)
	@mkdir -p $(dir $@)
	$(COMP) -c $< -o $@

-include $(DEPS)

# RULES ===============================================================================
# build -------------------------------------------------------------------------------
all : $(NAME)

# clean -------------------------------------------------------------------------------
clean:
	@rm -rf $(DIR_BUILD)

fclean: clean
	@rm -f $(NAME)
	
re: fclean all

.DEFAULT_GOAL = all

# debug -------------------------------------------------------------------------------
print-%:
	@echo $($(patsubst print-%,%,$@))

.PHONY: all clean fclean re print-%