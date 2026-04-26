import 'package:flutter/material.dart';
import 'package:fitassistent/theme/app_theme.dart';
import 'package:fitassistent/theme/platform_colors.dart';
import 'package:fitassistent/theme/platform_sizes.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const int _pagesCount = 4;
  static const double _cardRadius = 28;
  static const double _indicatorDotSize = 10;
  static const double _indicatorDotSpacing = 8;
  static const double _bottomIndicatorPadding = 24;
  static const double _actionButtonSize = 56;
  static const double _actionButtonIconSize = 28;
  static const double _navButtonBorderWidth = 2;
  static const Color _navButtonBorderColor = Color(0xFFFFFFFF);
  static const double _navButtonHorizontalPadding = 24;
  static const double _navButtonBottomPadding = 64;
  static const Duration _uiAnimDuration = Duration(milliseconds: 220);

  final _controller = PageController();
  final _nameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  final _budgetController = TextEditingController();

  int _index = 0;
  _Gender? _gender;
  _Goal? _goal;

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _next() {
    if (_index == 0 && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Введите имя')));
      return;
    }
    if (_index == 1) {
      final nameOk = _nameController.text.trim().isNotEmpty;
      final heightOk = _heightController.text.trim().isNotEmpty;
      final weightOk = _weightController.text.trim().isNotEmpty;
      final ageOk = _ageController.text.trim().isNotEmpty;
      final genderOk = _gender != null;

      if (!nameOk || !heightOk || !weightOk || !ageOk || !genderOk) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Заполните все поля чтобы продолжить')),
        );
        return;
      }
    }
    if (_index == 2) {
      if (_budgetController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Заполните все поля чтобы продолжить')),
        );
        return;
      }
    }
    if (_index == 3) {
      if (_goal == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Заполните все поля чтобы продолжить')),
        );
        return;
      }
    }
    if (_index >= _pagesCount - 1) {
      Navigator.of(context).pop();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 340),
      curve: Curves.easeInOutCubic,
    );
  }

  void _back() {
    if (_index <= 0) return;
    _controller.previousPage(
      duration: const Duration(milliseconds: 340),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.platformColors;

    return Scaffold(
      backgroundColor: colors.authScreenBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: SizedBox.expand(
            child: Container(
              decoration: BoxDecoration(
                color: colors.authCardBackground,
                borderRadius: BorderRadius.circular(_cardRadius),
              ),
              child: Stack(
                children: [
                  PageView(
                    controller: _controller,
                    onPageChanged: (value) => setState(() => _index = value),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _NameStep(controller: _nameController),
                      _AboutStep(
                        nameController: _nameController,
                        heightController: _heightController,
                        weightController: _weightController,
                        ageController: _ageController,
                        gender: _gender,
                        onGenderChanged: (value) =>
                            setState(() => _gender = value),
                      ),
                      _BudgetStep(
                        nameController: _nameController,
                        budgetController: _budgetController,
                      ),
                      _GoalStep(
                        goal: _goal,
                        onGoalChanged: (value) =>
                            setState(() => _goal = value),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: _bottomIndicatorPadding,
                    child: _PageIndicator(
                      count: _pagesCount,
                      index: _index,
                      activeColor: colors.primaryColor,
                      inactiveColor: colors.authDividerColor,
                    ),
                  ),
                  Positioned(
                    left: _navButtonHorizontalPadding,
                    bottom: _navButtonBottomPadding,
                    child: AnimatedOpacity(
                      duration: _uiAnimDuration,
                      curve: Curves.easeInOut,
                      opacity: _index > 0 ? 1 : 0,
                      child: IgnorePointer(
                        ignoring: _index == 0,
                        child: SizedBox(
                          width: _actionButtonSize,
                          height: _actionButtonSize,
                          child: ElevatedButton(
                            onPressed: _back,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(
                                side: BorderSide(
                                  color: _navButtonBorderColor,
                                  width: _navButtonBorderWidth,
                                ),
                              ),
                              backgroundColor: colors.authCardBackground,
                              foregroundColor: colors.textPrimary,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              alignment: Alignment.center,
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              size: _actionButtonIconSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: _navButtonHorizontalPadding,
                    bottom: _navButtonBottomPadding,
                    child: SizedBox(
                      width: _actionButtonSize,
                      height: _actionButtonSize,
                      child: ElevatedButton(
                        onPressed: _next,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(
                            side: BorderSide(
                              color: _navButtonBorderColor,
                              width: _navButtonBorderWidth,
                            ),
                          ),
                          backgroundColor: colors.authCardBackground,
                          foregroundColor: colors.textPrimary,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          alignment: Alignment.center,
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          size: _actionButtonIconSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NameStep extends StatelessWidget {
  const _NameStep({required this.controller});

  static const double _horizontalPadding = 28;
  static const double _contentMaxWidth = 520;
  static const double _titleFontSize = 28;

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.platformColors;
    final sizes = context.platformSizes;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Давай знакомиться!',
                style: context.platformTextStyles.h2SemiBold.copyWith(
                  fontSize: _titleFontSize,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Как тебя зовут?',
                style: TextStyle(color: colors.textPrimary),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: sizes.inputFieldHeight,
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colors.authFieldBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: colors.authFieldBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: colors.authFieldBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: colors.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _Gender { male, female }

enum _Goal { massGain, weightLoss, maintainWeight }

class _SelectablePillButton extends StatelessWidget {
  const _SelectablePillButton({
    required this.selected,
    required this.height,
    required this.borderRadius,
    required this.selectedBackground,
    required this.selectedForeground,
    required this.unselectedBackground,
    required this.unselectedForeground,
    required this.onPressed,
    required this.child,
  });

  static const Duration _duration = _OnboardingPageState._uiAnimDuration;

  final bool selected;
  final double height;
  final double borderRadius;
  final Color selectedBackground;
  final Color selectedForeground;
  final Color unselectedBackground;
  final Color unselectedForeground;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final background = selected ? selectedBackground : unselectedBackground;
    final foreground = selected ? selectedForeground : unselectedForeground;

    return SizedBox(
      height: height,
      child: AnimatedContainer(
        duration: _duration,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: onPressed,
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: _duration,
                curve: Curves.easeInOut,
                style: TextStyle(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoalStep extends StatelessWidget {
  const _GoalStep({
    required this.goal,
    required this.onGoalChanged,
  });

  static const double _horizontalPadding = 28;
  static const double _contentMaxWidth = 520;
  static const double _titleFontSize = 28;
  static const double _buttonSpacing = 18;
  static const double _borderRadius = 16;

  final _Goal? goal;
  final ValueChanged<_Goal> onGoalChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.platformColors;
    final sizes = context.platformSizes;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Какова ваша цель?',
                textAlign: TextAlign.center,
                style: context.platformTextStyles.h2SemiBold.copyWith(
                  fontSize: _titleFontSize,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 34),
              _SelectablePillButton(
                selected: goal == _Goal.massGain,
                height: sizes.navigationButtonHeight,
                borderRadius: _borderRadius,
                selectedBackground: colors.authPrimaryButtonBackground,
                selectedForeground: colors.authPrimaryButtonText,
                unselectedBackground: colors.authSecondaryButtonBackground,
                unselectedForeground: colors.authSecondaryButtonText,
                onPressed: () => onGoalChanged(_Goal.massGain),
                child: const Text('Набор массы'),
              ),
              const SizedBox(height: _buttonSpacing),
              _SelectablePillButton(
                selected: goal == _Goal.weightLoss,
                height: sizes.navigationButtonHeight,
                borderRadius: _borderRadius,
                selectedBackground: colors.authPrimaryButtonBackground,
                selectedForeground: colors.authPrimaryButtonText,
                unselectedBackground: colors.authSecondaryButtonBackground,
                unselectedForeground: colors.authSecondaryButtonText,
                onPressed: () => onGoalChanged(_Goal.weightLoss),
                child: const Text('Похудение'),
              ),
              const SizedBox(height: _buttonSpacing),
              _SelectablePillButton(
                selected: goal == _Goal.maintainWeight,
                height: sizes.navigationButtonHeight,
                borderRadius: _borderRadius,
                selectedBackground: colors.authPrimaryButtonBackground,
                selectedForeground: colors.authPrimaryButtonText,
                unselectedBackground: colors.authSecondaryButtonBackground,
                unselectedForeground: colors.authSecondaryButtonText,
                onPressed: () => onGoalChanged(_Goal.maintainWeight),
                child: const Text('Вес'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BudgetStep extends StatelessWidget {
  const _BudgetStep({
    required this.nameController,
    required this.budgetController,
  });

  static const double _horizontalPadding = 28;
  static const double _contentMaxWidth = 520;
  static const double _titleFontSize = 28;
  static const double _labelFontSize = 16;
  static const FontWeight _labelWeight = FontWeight.w700;
  static const double _labelBottomPadding = 8;
  static const double _borderRadius = 16;
  static const double _horizontalFieldPadding = 16;
  static const double _verticalFieldPadding = 18;
  static const double _blockTopSpacing = 18;

  final TextEditingController nameController;
  final TextEditingController budgetController;

  @override
  Widget build(BuildContext context) {
    final colors = context.platformColors;
    final sizes = context.platformSizes;

    final name = nameController.text.trim();
    final titleName = name.isEmpty ? 'Имя' : name;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$titleName, расскажи о себе',
                style: context.platformTextStyles.h2SemiBold.copyWith(
                  fontSize: _titleFontSize,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: _blockTopSpacing),
              Padding(
                padding: const EdgeInsets.only(bottom: _labelBottomPadding),
                child: Text(
                  'Ваш бюджет',
                  style: TextStyle(
                    fontSize: _labelFontSize,
                    fontWeight: _labelWeight,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              SizedBox(
                height: sizes.inputFieldHeight,
                child: TextField(
                  controller: budgetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: colors.authFieldBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(_borderRadius),
                      borderSide: BorderSide(color: colors.authFieldBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(_borderRadius),
                      borderSide: BorderSide(color: colors.authFieldBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(_borderRadius),
                      borderSide: BorderSide(
                        color: colors.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: _horizontalFieldPadding,
                      vertical: _verticalFieldPadding,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.recomendationBlockBackground,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Рекомендация',
                      style: TextStyle(
                        fontSize: _labelFontSize,
                        fontWeight: _labelWeight,
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Минимальный бюджет для сбалансированного питания: 2000 - 2500 руб/неделя',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutStep extends StatelessWidget {
  const _AboutStep({
    required this.nameController,
    required this.heightController,
    required this.weightController,
    required this.ageController,
    required this.gender,
    required this.onGenderChanged,
  });

  static const double _horizontalPadding = 28;
  static const double _contentMaxWidth = 520;
  static const double _titleFontSize = 28;
  static const double _fieldSpacing = 14;
  static const double _labelSpacing = 8;
  static const double _genderSpacing = 16;
  static const double _borderRadius = 16;

  final TextEditingController nameController;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final TextEditingController ageController;
  final _Gender? gender;
  final ValueChanged<_Gender> onGenderChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.platformColors;
    final sizes = context.platformSizes;

    final name = nameController.text.trim();
    final titleName = name.isEmpty ? 'Имя' : name;
    final isMaleSelected = gender == _Gender.male;
    final isFemaleSelected = gender == _Gender.female;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$titleName, расскажи о себе',
                style: context.platformTextStyles.h2SemiBold.copyWith(
                  fontSize: _titleFontSize,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 18),
              _LabeledField(
                label: 'Ваш рост',
                controller: heightController,
                hintText: 'Рост(см)',
                sizes: sizes,
                colors: colors,
              ),
              const SizedBox(height: _fieldSpacing),
              _LabeledField(
                label: 'Ваш вес',
                controller: weightController,
                hintText: 'Вес(кг)',
                sizes: sizes,
                colors: colors,
              ),
              const SizedBox(height: _fieldSpacing),
              _LabeledField(
                label: 'Ваш возраст',
                controller: ageController,
                hintText: 'Возраст (лет)',
                sizes: sizes,
                colors: colors,
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: _SelectablePillButton(
                      selected: isMaleSelected,
                      height: sizes.navigationButtonHeight,
                      borderRadius: _borderRadius,
                      selectedBackground: colors.authPrimaryButtonBackground,
                      selectedForeground: colors.authPrimaryButtonText,
                      unselectedBackground: colors.authSecondaryButtonBackground,
                      unselectedForeground: colors.authSecondaryButtonText,
                      onPressed: () => onGenderChanged(_Gender.male),
                      child: const Text('Мужской'),
                    ),
                  ),
                  const SizedBox(width: _genderSpacing),
                  Expanded(
                    child: _SelectablePillButton(
                      selected: isFemaleSelected,
                      height: sizes.navigationButtonHeight,
                      borderRadius: _borderRadius,
                      selectedBackground: colors.authPrimaryButtonBackground,
                      selectedForeground: colors.authPrimaryButtonText,
                      unselectedBackground: colors.authSecondaryButtonBackground,
                      unselectedForeground: colors.authSecondaryButtonText,
                      onPressed: () => onGenderChanged(_Gender.female),
                      child: const Text('Женский'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: _labelSpacing),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    required this.hintText,
    required this.sizes,
    required this.colors,
  });

  static const double _labelFontSize = 16;
  static const FontWeight _labelWeight = FontWeight.w700;
  static const double _labelBottomPadding = 8;
  static const double _borderRadius = 16;
  static const double _horizontalFieldPadding = 16;
  static const double _verticalFieldPadding = 18;

  final String label;
  final TextEditingController controller;
  final String hintText;
  final PlatformSizes sizes;
  final PlatformColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: _labelBottomPadding),
          child: Text(
            label,
            style: TextStyle(
              fontSize: _labelFontSize,
              fontWeight: _labelWeight,
              color: colors.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: sizes.inputFieldHeight,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: colors.authHintTextColor),
              isDense: true,
              filled: true,
              fillColor: colors.authFieldBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(_borderRadius),
                borderSide: BorderSide(color: colors.authFieldBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(_borderRadius),
                borderSide: BorderSide(color: colors.authFieldBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(_borderRadius),
                borderSide: BorderSide(color: colors.primaryColor, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: _horizontalFieldPadding,
                vertical: _verticalFieldPadding,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.count,
    required this.index,
    required this.activeColor,
    required this.inactiveColor,
  });

  static const double _dotSize = _OnboardingPageState._indicatorDotSize;
  static const double _dotSpacing = _OnboardingPageState._indicatorDotSpacing;
  static const Duration _duration = _OnboardingPageState._uiAnimDuration;
  static const double _activeScale = 1.25;

  final int count;
  final int index;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == index;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: _dotSpacing / 2),
          child: AnimatedContainer(
            duration: _duration,
            curve: Curves.easeInOut,
            width: isActive ? _dotSize * _activeScale : _dotSize,
            height: _dotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? activeColor : inactiveColor,
            ),
          ),
        );
      }),
    );
  }
}
