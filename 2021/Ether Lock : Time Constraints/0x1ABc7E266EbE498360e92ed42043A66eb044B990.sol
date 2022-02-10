['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.8.6;\n', '\n', 'interface IERC20 {\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '}\n', '\n', 'contract Atm {\n', '    uint256 public constant SHARE_DENOMINATOR = 10000;\n', '    IERC20 public immutable token;\n', '\n', '    uint256 public depositTotal;\n', '    uint256 public withdrawTotal;\n', '\n', '    mapping(address => uint256) public shares;\n', '    mapping(address => uint256) public withdrawn;\n', '\n', '    modifier updateDeposits {\n', '        depositTotal += (token.balanceOf(address(this)) + withdrawTotal - depositTotal);\n', '        _;\n', '    }\n', '\n', '    event Withdraw(address wallet, uint256 amount);\n', '\n', '    constructor(IERC20 _token, address[] memory _wallets, uint256[] memory _shares) {\n', '        require(_wallets.length == _shares.length, "ATM: corrupt data");\n', '\n', '        token = _token;\n', '\n', '        for (uint256 i = 0; i < _wallets.length; i++) {\n', '            shares[_wallets[i]] = _shares[i];\n', '        }\n', '    }\n', '\n', '    function currentDepositTotal() public view returns (uint256) {\n', '        uint256 _depositTotal = depositTotal;\n', '        _depositTotal += (token.balanceOf(address(this)) + withdrawTotal - depositTotal);\n', '        return _depositTotal;\n', '    }\n', '\n', '    function available(address wallet) public view returns (uint256) {\n', '        uint256 totalWithdraw = currentDepositTotal() * shares[wallet] / SHARE_DENOMINATOR;\n', '        return totalWithdraw - withdrawn[wallet];\n', '    }\n', '\n', '    function withdraw() external updateDeposits {\n', '        require(shares[msg.sender] > 0, "ATM: no shares");\n', '\n', '        uint256 availableWithdraw = available(msg.sender);\n', '\n', '        withdrawn[msg.sender] += availableWithdraw;\n', '        withdrawTotal += availableWithdraw;\n', '\n', '        emit Withdraw(msg.sender, availableWithdraw);\n', '\n', '        token.transfer(msg.sender, availableWithdraw);\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "metadata": {\n', '    "useLiteralContent": true\n', '  },\n', '  "libraries": {\n', '    "": {\n', '      "__CACHE_BREAKER__": "0x00000000d41867734bbee4c6863d9255b2b06ac1"\n', '    }\n', '  }\n', '}']