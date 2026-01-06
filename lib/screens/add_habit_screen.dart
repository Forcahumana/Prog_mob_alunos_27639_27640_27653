import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import '../utils/constants.dart';

class AddHabitScreen extends StatefulWidget {
  final Habit? habitToEdit;

  const AddHabitScreen({super.key, this.habitToEdit});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedIcon = '🎯';
  String _selectedCategory = 'Geral';
  int _xpReward = 10;
  int _targetDays = 30;

  bool get isEditing => widget.habitToEdit != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.habitToEdit!.name;
      _descriptionController.text = widget.habitToEdit!.description;
      _selectedIcon = widget.habitToEdit!.icon;
      _selectedCategory = widget.habitToEdit!.category;
      _xpReward = widget.habitToEdit!.xpReward;
      _targetDays = widget.habitToEdit!.targetDays;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Hábito' : 'Novo Hábito'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Seletor de ícone
            _buildIconSelector(),
            const SizedBox(height: 24),

            // Nome do hábito
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Hábito',
                hintText: 'Ex: Beber 2L de água',
                prefixIcon: Icon(Icons.edit),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insere um nome';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Descrição
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                hintText: 'Ex: Manter-se hidratado durante o dia',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insere uma descrição';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Categoria
            _buildCategorySelector(),
            const SizedBox(height: 24),

            // XP Reward
            _buildXpSelector(),
            const SizedBox(height: 24),

            // Meta de dias
            _buildTargetDaysSelector(),
            const SizedBox(height: 24),

            // Sugestões rápidas (apenas para novo hábito)
            if (!isEditing) ...[
              const Text(
                'Sugestões Rápidas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _buildSuggestions(),
            ],

            const SizedBox(height: 32),

            // Botão de guardar
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _saveHabit,
                child: Text(isEditing ? 'Guardar Alterações' : 'Criar Hábito'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ícone',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.habitIcons.map((icon) {
                final isSelected = icon == _selectedIcon;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = icon;
                    });
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        icon,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categoria',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.habitCategories.map((category) {
                final isSelected = category['name'] == _selectedCategory;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category['name']!;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(category['icon']!),
                        const SizedBox(width: 6),
                        Text(
                          category['name']!,
                          style: TextStyle(
                            color: isSelected ? Colors.white : null,
                            fontWeight: isSelected ? FontWeight.w600 : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildXpSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recompensa XP',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '+$_xpReward XP',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Hábitos mais difíceis merecem mais XP',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Slider(
              value: _xpReward.toDouble(),
              min: 5,
              max: 50,
              divisions: 9,
              label: '$_xpReward XP',
              onChanged: (value) {
                setState(() {
                  _xpReward = value.toInt();
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('5 XP', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                Text('50 XP', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetDaysSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Meta de Dias',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$_targetDays dias',
                    style: const TextStyle(
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Quantos dias queres manter este hábito',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Slider(
              value: _targetDays.toDouble(),
              min: 7,
              max: 90,
              divisions: 11,
              label: '$_targetDays dias',
              onChanged: (value) {
                setState(() {
                  _targetDays = value.toInt();
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('7 dias', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                Text('90 dias', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: AppConstants.habitSuggestions.length,
        itemBuilder: (context, index) {
          final suggestion = AppConstants.habitSuggestions[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _nameController.text = suggestion['name'];
                _descriptionController.text = suggestion['description'];
                _selectedIcon = suggestion['icon'];
                _selectedCategory = suggestion['category'];
                _xpReward = suggestion['xpReward'];
              });
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion['icon'],
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    suggestion['name'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    '+${suggestion['xpReward']} XP',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<HabitProvider>();

      if (isEditing) {
        final updatedHabit = widget.habitToEdit!.copyWith(
          name: _nameController.text,
          description: _descriptionController.text,
          icon: _selectedIcon,
          category: _selectedCategory,
          xpReward: _xpReward,
          targetDays: _targetDays,
        );
        provider.updateHabit(updatedHabit);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hábito atualizado!')),
        );
      } else {
        final newHabit = Habit(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text,
          description: _descriptionController.text,
          icon: _selectedIcon,
          category: _selectedCategory,
          xpReward: _xpReward,
          targetDays: _targetDays,
        );
        provider.addHabit(newHabit);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hábito criado! +10 XP 🎉')),
        );
      }

      Navigator.pop(context);
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Hábito'),
        content: const Text(
          'Tens a certeza que queres eliminar este hábito? Todo o progresso será perdido.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<HabitProvider>().deleteHabit(widget.habitToEdit!.id);
              Navigator.pop(context); // Fecha o dialog
              Navigator.pop(context); // Volta para o ecrã anterior
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Hábito eliminado')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

