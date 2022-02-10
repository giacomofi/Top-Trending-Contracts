['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-16\n', '*/\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity 0.7.6;\n', '\n', '// iWSCRT Interface\n', 'interface iWSCRT {\n', '    function transfer(address, uint) external returns (bool);\n', '    function transferTo(address, uint) external returns (bool);\n', '}\n', '\n', '// Sushiswap Interface\n', 'interface iPair {\n', '    function sync() external;\n', '}\n', '\n', 'contract Incentives {\n', '    address public WSCRT = 0x2B89bF8ba858cd2FCee1faDa378D5cd6936968Be;\n', '    event Deposited(address indexed pair, uint amount);\n', '\n', '    constructor() {}\n', '\n', '    // #### DEPOSIT ####\n', '\n', '    // Deposit and sync\n', '    function depositIncentives(address pair, uint amount) public {\n', '        _getWscrt(amount);\n', '        _depositAndSync(pair, amount);\n', '    }\n', '    // Deposit and sync batches\n', '    function depositBatchIncentives(address[] memory pairs, uint[] memory amounts) public {\n', '        uint _amountToGet = 0;\n', '        for(uint i = 0; i < pairs.length; i++){\n', '            _amountToGet += amounts[i];\n', '        }\n', '        _getWscrt(_amountToGet);\n', '        for(uint i = 0; i < pairs.length; i++){\n', '            _depositAndSync(pairs[i], amounts[i]);\n', '        }\n', '    }\n', '\n', '    // #### HELPERS ####\n', '\n', '    function _toGrains(uint _amount) internal pure returns(uint){\n', '        return _amount * 10**6;\n', '    }\n', '\n', '    function _getWscrt(uint _amount) internal {\n', '        iWSCRT(WSCRT).transferTo(address(this), _toGrains(_amount));\n', '    }\n', '\n', '    function _depositAndSync(address _pair, uint _amount) internal {\n', '        iWSCRT(WSCRT).transfer(_pair, _toGrains(_amount));\n', '        iPair(_pair).sync();\n', '        emit Deposited(_pair, _amount);\n', '    }\n', '\n', '}']