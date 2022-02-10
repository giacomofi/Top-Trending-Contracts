['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.5.17;\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, "add: +");\n', '\n', '        return c;\n', '    }\n', '    function add(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, errorMessage);\n', '\n', '        return c;\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        return sub(a, b, "sub: -");\n', '    }\n', '    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        require(b <= a, errorMessage);\n', '        uint c = a - b;\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', 'interface IKeep3rV1 {\n', '    function isMinKeeper(address keeper, uint minBond, uint earned, uint age) external returns (bool);\n', '    function receipt(address credit, address keeper, uint amount) external;\n', '    function unbond(address bonding, uint amount) external;\n', '    function withdraw(address bonding) external;\n', '    function bonds(address keeper, address credit) external view returns (uint);\n', '    function unbondings(address keeper, address credit) external view returns (uint);\n', '    function approve(address spender, uint amount) external returns (bool);\n', '    function jobs(address job) external view returns (bool);\n', '    function balanceOf(address account) external view returns (uint256);\n', '}\n', '\n', 'interface WETH9 {\n', '    function withdraw(uint wad) external;\n', '}\n', '\n', 'interface IUniswapV2Router {\n', '    function swapExactTokensForTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '}\n', '\n', 'interface IKeep3rJob {\n', '    function work() external;\n', '}\n', '\n', 'contract MetaKeep3r {\n', '    using SafeMath for uint;\n', '    \n', '    modifier upkeep() {\n', '        require(KP3R.isMinKeeper(msg.sender, 100e18, 0, 0), "MetaKeep3r::isKeeper: keeper is not registered");\n', '        uint _before = KP3R.bonds(address(this), address(KP3R));\n', '        _;\n', '        uint _after = KP3R.bonds(address(this), address(KP3R));\n', '        uint _received = _after.sub(_before);\n', '        uint _balance = KP3R.balanceOf(address(this));\n', '        if (_balance < _received) {\n', '            KP3R.receipt(address(KP3R), address(this), _received.sub(_balance));\n', '        }\n', '        _received = _swap(_received);\n', '        msg.sender.transfer(_received);\n', '    }\n', '    \n', '    function task(address job, bytes calldata data) external upkeep {\n', '        require(KP3R.jobs(job), "MetaKeep3r::work: invalid job");\n', '        (bool success,) = job.call.value(0)(data);\n', '        require(success, "MetaKeep3r::work: job failure");\n', '    }\n', '    \n', '    function work(address job) external upkeep {\n', '        require(KP3R.jobs(job), "MetaKeep3r::work: invalid job");\n', '        IKeep3rJob(job).work();\n', '    }\n', '    \n', '    IKeep3rV1 public constant KP3R = IKeep3rV1(0x1cEB5cB57C4D4E2b2433641b95Dd330A33185A44);\n', '    WETH9 public constant WETH = WETH9(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);\n', '    IUniswapV2Router public constant UNI = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n', '    \n', '    function unbond() external {\n', '        require(KP3R.unbondings(address(this), address(KP3R)) < now, "MetaKeep3r::unbond: unbonding");\n', '        KP3R.unbond(address(KP3R), KP3R.bonds(address(this), address(KP3R)));\n', '    }\n', '    \n', '    function withdraw() external {\n', '        KP3R.withdraw(address(KP3R));\n', '        KP3R.unbond(address(KP3R), KP3R.bonds(address(this), address(KP3R)));\n', '    }\n', '    \n', '    function() external payable {}\n', '    \n', '    function _swap(uint _amount) internal returns (uint) {\n', '        KP3R.approve(address(UNI), _amount);\n', '        \n', '        address[] memory path = new address[](2);\n', '        path[0] = address(KP3R);\n', '        path[1] = address(WETH);\n', '\n', '        uint[] memory amounts = UNI.swapExactTokensForTokens(_amount, uint256(0), path, address(this), now.add(1800));\n', '        WETH.withdraw(amounts[1]);\n', '        return amounts[1];\n', '    }\n', '}']