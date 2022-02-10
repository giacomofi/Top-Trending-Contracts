['pragma solidity ^0.4.23;\n', '\n', 'interface P3D {\n', '  function() payable external;\n', '  function buy(address _playerAddress) payable external returns(uint256);\n', '  function sell(uint256 _amountOfTokens) external;\n', '  function reinvest() external;\n', '  function withdraw() external;\n', '  function exit() external;\n', '  function dividendsOf(address _playerAddress) external view returns(uint256);\n', '  function balanceOf(address _playerAddress) external view returns(uint256);\n', '  function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);\n', '  function stakingRequirement() external view returns(uint256);\n', '  function myDividends(bool _includeReferralBonus) external view returns(uint256);\n', '}\n', '\n', 'contract ProxyCrop {\n', '    address public owner;\n', '    bool public disabled;\n', '\n', '    constructor(address _owner, address _referrer) public payable {\n', '      owner = _owner;\n', '\n', '      // plant some seeds\n', '      if (msg.value > 0) {\n', '        P3D(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe).buy.value(msg.value)(_referrer);\n', '      }\n', '    }\n', '\n', '    function() public payable {\n', '      assembly {\n', '        // Copy msg.data. We take full control of memory in this inline assembly\n', '        // block because it will not return to Solidity code. We overwrite the\n', '        // Solidity scratch pad at memory position 0.\n', '        calldatacopy(0, 0, calldatasize)\n', '\n', '        // Call the implementation.\n', "        // out and outsize are 0 because we don't know the size yet.\n", '        let result := delegatecall(gas, 0x0D6C969d0004B431189f834203CE0f5530e06259, 0, calldatasize, 0, 0)\n', '\n', '        // Copy the returned data.\n', '        returndatacopy(0, 0, returndatasize)\n', '\n', '        switch result\n', '        // delegatecall returns 0 on error.\n', '        case 0 { revert(0, returndatasize) }\n', '        default { return(0, returndatasize) }\n', '      }\n', '    }\n', '}']