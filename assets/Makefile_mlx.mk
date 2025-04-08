# GENERAL SETTINGS ====================================================================
# NAME = <NAME OF YOUR PROGRAM>
LIB_NAME = lib_improved
MLX_NAME = mlx_linux
.SILENT:

# DIRECTORIES==========================================================================
DIR_SRC		:= sources/
DIR_INC 	:= includes/
DIR_BUILD	:= .build/

DIR_LIB		:= $(LIB_NAME)/
DIR_INC_LIB	:= $(DIR_LIB)includes/

DIR_MLX 	:= $(MLX_NAME)/

# FLAGS & COMPILATOR SETTINGS =========================================================
CC 			:= cc
DEPS_FLAGS  := -MMD -MP
WARN_FLAGS	:= -Wall -Werror -Wextra
C_FLAGS		:= $(WARN_FLAGS) $(DEPS_FLAGS)
INC_FLAGS 	:= -I$(DIR_INC) -I$(DIR_INC_LIB) -I/usr/include -I$(MLX_NAME)
LIB_FLAGS	:= -L$(DIR_LIB) -l_improved
MLX_FLAGS	:= -L$(MLX_NAME) -lmlx_Linux -L/usr/lib -lXext -lX11 -lm -lz


COMP 		:= $(CC) $(C_FLAGS) $(INC_FLAGS)
LINK		:= $(LIB_FLAGS) $(MLX_FLAGS)

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
all : lib mlx $(NAME)

lib :
	@make -s -C $(DIR_LIB)

mlx :
	@make -s -C $(DIR_MLX)

# clean -------------------------------------------------------------------------------
clean:
	@make -s clean -C $(DIR_LIB)
	@make -s clean -C $(DIR_MLX)
	@rm -rf $(DIR_BUILD)

fclean: clean
	@make -s fclean -C $(DIR_LIB)
	@rm -f $(NAME)
	
re: fclean all

.DEFAULT_GOAL = all

# debug -------------------------------------------------------------------------------
print-%:
	@echo $($(patsubst print-%,%,$@))

.PHONY: all lib mlx clean fclean re print-%