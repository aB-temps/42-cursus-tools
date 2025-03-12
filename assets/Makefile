# GENERAL SETTINGS =======================================================================
CC = cc
CFLAGS = -Wall -Werror -Wextra
# NAME = XXXXXX
LIB_NAME = lib-improved
# .SILENT:

# COMPONENTS =============================================================================
COMPONENTS :=	XXXXXX \
				XXXXXX

# FUNCTIONS ==============================================================================
define generate_var_sources_dir
DIR_$(1) = $$(addprefix $$(DIR_SRC), $(shell echo $(1) | tr '[:upper:]' '[:lower:]')/)
endef

define generate_var_sources
SRC_$(1) = $$(addprefix $$(DIR_$(1)),$$(F_$(1)))
endef

define generate_var_objects
OBJ_$(1) = $$(patsubst $$(DIR_SRC)%.c,$$(DIR_OBJ)/%.o,$$(SRC_$(1)))
endef

# FILES ==================================================================================

F_LIB = $(addsuffix .a, $(LIB_NAME))

F_MAIN :=		main.c

F_XXXXX :=		xxxxx.c

# DIR ==================================================================================
DIR_INC = includes/
DIR_LIB = $(LIB_NAME)/
DIR_LIB_INC = $(addprefix $(DIR_LIB), $(DIR_INC))
DIR_SRC = sources/
DIR_OBJ = .objects/
$(foreach comp,$(COMPONENTS),$(eval $(call generate_var_sources_dir,$(comp))))

# INCLUDE ==============================================================================
INCLUDE_HDR = $(addprefix $(DIR_INC),$(F_INC))
INCLUDE_LIB = $(addprefix $(DIR_LIB),$(F_LIB))
INCLUDE_LIB_HDR = $(addprefix $(DIR_LIB), $(addsuffix .h, $(subst -,_,$(LIB_NAME))))

# SOURCES =============================================================================
$(foreach comp,$(COMPONENTS),$(eval $(call generate_var_sources,$(comp))))


# OBJECTS =============================================================================
$(foreach comp,$(COMPONENTS),$(eval $(call generate_var_objects,$(comp))))

OBJECTS := 	$(foreach comp, $(COMPONENTS), $(OBJ_$(comp))) \
			$(DIR_OBJ)main.o

$(DIR_OBJ):
	mkdir -p $@

$(DIR_OBJ)/%.o: $(DIR_SRC)%.c $(DIR_INC)/* $(DIR_LIB_INC)/*
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -I $(DIR_INC) -I $(DIR_LIB_INC) -o $@ -g3

# RULES ===============================================================================
# make --------------------------------------------------------------------------------
all : lib $(NAME)

lib :
	make -C $(DIR_LIB)

$(NAME): $(DIR_OBJ) $(OBJECTS) $(DIR_LIB)$(F_LIB)
	$(CC) $(CFLAGS) -o $@ $(OBJECTS) -L$(DIR_LIB) -l$(patsubst lib%.a,%,$(F_LIB))
	@echo ✨ $(NAME) compiled ✨

clean:
	make clean -C $(DIR_LIB)
	rm -rf $(DIR_OBJ)

fclean: clean
	make fclean -C $(DIR_LIB)
	rm -f $(NAME)
	
re: fclean all

# debug --------------------------------------------------------------------------------

print-%:
	@echo $($(patsubst print-%,%,$@))

.DEFAULT_GOAL = all

.PHONY: all clean fclean re print-%