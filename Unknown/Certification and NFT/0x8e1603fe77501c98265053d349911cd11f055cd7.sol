['pragma solidity ^0.4.13;\n', '\n', 'contract Calculator {\n', '    function getAmount(uint value) constant returns (uint);\n', '}\n', '\n', 'contract BonusCalculator {\n', '    function getBonus() constant returns (uint);\n', '}\n', '\n', 'contract BonusAwareCalculator is Calculator {\n', '    Calculator delegate;\n', '\n', '    BonusCalculator bonusCalculator;\n', '\n', '    function BonusAwareCalculator(address delegateAddress, address bonusCalculatorAddress) {\n', '        delegate = Calculator(delegateAddress);\n', '        bonusCalculator = BonusCalculator(bonusCalculatorAddress);\n', '    }\n', '\n', '    function getAmount(uint value) constant returns (uint) {\n', '        uint withoutBonus = delegate.getAmount(value);\n', '        uint bonusPercent = bonusCalculator.getBonus();\n', '        uint bonus = withoutBonus * bonusPercent / 100;\n', '        return withoutBonus + bonus;\n', '    }\n', '}']