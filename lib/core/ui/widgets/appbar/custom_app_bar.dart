import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final VoidCallback? onClose;
  final VoidCallback? onFilter;

  const CustomAppBar({
    super.key,
    this.onChanged,
    this.onSubmit,
    this.onClose,
    this.onFilter,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  bool _isSearchExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _widthAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _expandSearch() {
    setState(() {
      _isSearchExpanded = true;
    });
    _animationController.forward().then((_) {
      _searchFocusNode.requestFocus();
    });
  }

  void _collapseSearch() {
    _searchFocusNode.unfocus();
    _searchController.clear();
    widget.onClose?.call();
    
    _animationController.reverse().then((_) {
      setState(() {
        _isSearchExpanded = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: !_isSearchExpanded ? const Image(
        width: 180,
        image: AssetImage('assets/images/name_logo_right.png'),
      ) : null,
      backgroundColor: theme.colorScheme.surface,
      actions: [
        if (_isSearchExpanded) ...[
          // Botão de voltar
          IconButton(
            icon: const Icon(Icons.arrow_back),
            color: theme.colorScheme.onSurface,
            onPressed: _collapseSearch,
          ),
          
          // Campo de busca expandido
          Expanded(
            child: AnimatedBuilder(
              animation: _widthAnimation,
              builder: (context, child) {
                return Container(
                  margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Buscar...',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: _collapseSearch,
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                    onChanged: widget.onChanged,
                    onSubmitted: (value) {
                      widget.onSubmit?.call(value);
                      //_collapseSearch();
                    },
                    textInputAction: TextInputAction.search,
                  ),
                );
              },
            ),
          ),
        ] else ...[
          // Ícone de filtro
          if (widget.onFilter != null)
            IconButton(
              icon: const Icon(Icons.filter_list),
              color: theme.colorScheme.onSurface,
              onPressed: widget.onFilter,
            ),
          // Ícone de busca
          IconButton(
            icon: const Icon(Icons.search),
            color: theme.colorScheme.onSurface,
            onPressed: _expandSearch,
          ),
        ],
      ],
    );
  }
}
