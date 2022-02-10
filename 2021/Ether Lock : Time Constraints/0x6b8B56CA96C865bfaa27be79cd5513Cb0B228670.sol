['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-29\n', '*/\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', 'pragma solidity ^0.8.4;\n', '\n', '// 升级合约\n', 'contract Nest36Withdraw {\n', '\n', '\t//==========NHBTC未领取参数\n', '\t// NHBTC Owner\n', '\taddress constant NHBTC_OWNER = 0x3CeeFBbB0e6C60cf64DB9D17B94917D6D78cec05;\n', '\t// NHBTC地址\n', '\taddress constant NHBTC_ADDRESS = 0x1F832091fAf289Ed4f50FE7418cFbD2611225d46;\n', '\t// NHBTC未领取数量\n', '\t// uint256 constant NHBTC_AMOUNT = 38216800000000000000000;\n', '\t\n', '\n', '\t//==========NN未领取NEST参数\n', '\t// NN领取合约地址\n', '\taddress constant NNREWARDPOOL_ADDRESS = 0xf1A7201749fA81463799383D7D0565B6bfECE757;\n', '\t// NN未领取NEST数量\n', '\t// uint256 constant NN_NEST_AMOUNT = 3441295249408000000000000;\n', '\n', '\t//==========挖矿资金参数\n', '\t// 矿工0x4FD6CEAc4FF7c5F4d57A4043cbaA1862F227145A私钥出现问题，导致有两笔nest报价单(6886, 6885)不能正常关闭\n', '\t// 经其确认，两笔报价单内锁定的60eth和2996558.362758784295450000nest协助其转入到其提供的新地址0xA05684C9e3A1d62a4EBC5a9FFB13030Bbe5e82a8\n', '\t// 新矿工地址\n', '\taddress constant NEW_MINER = 0xA05684C9e3A1d62a4EBC5a9FFB13030Bbe5e82a8;\n', '\t// 挖矿ETH资金\n', '\tuint256 constant ETH_AMOUNT_MINING = 60000000000000000000;\n', '\t// 挖矿NEST资金\n', '\tuint256 constant NEST_AMOUNT_MINING = 2996558362758784295450000;\n', '\n', '\t// NEST地址\n', '\taddress constant NEST_ADDRESS = 0x04abEdA201850aC0124161F037Efd70c74ddC74C;\n', '\t// NEST3.5挖矿合约地址\n', '\taddress constant NEST_MINING_ADDRESS = 0x243f207F9358cf67243aDe4A8fF3C5235aa7b8f6;\n', '\t// 3.5矿池合约地址\n', '\taddress constant NEST_POOL_ADDRESS = 0xCA208DCfbEF22941D176858A640190C2222C8c8F;\n', '\n', '\t// 管理员\n', '    address public _owner;\n', '    \n', '    constructor() {\n', '        _owner = msg.sender;\n', '    }\n', '\n', '    // 恢复3.5管理员\n', '    function setGov35() public onlyOwner {\n', '        INestPool(NEST_POOL_ADDRESS).setGovernance(_owner);\n', '    }\n', '\n', '    function doit() public onlyOwner {\n', '    \tINestPool NestPool = INestPool(NEST_POOL_ADDRESS);\n', '    \t// 零:设置地址\n', '    \tNestPool.setContracts(address(0x0), address(this), address(0x0), address(0x0), address(0x0), address(0x0), address(0x0), address(0x0));\n', '\n', '    \t// 一:转移挖矿资金\n', '    \t// 1_1.更换ETH账本、更换NEST账本\n', '    \tNestPool.transferEthInPool(NEST_POOL_ADDRESS, NEW_MINER, ETH_AMOUNT_MINING);\n', '    \tNestPool.transferNestInPool(NEST_POOL_ADDRESS, NEW_MINER, NEST_AMOUNT_MINING);\n', '    \t// 1_2.给新矿工地址转ETH和NEST\n', '    \tNestPool.withdrawEthAndToken(NEW_MINER, ETH_AMOUNT_MINING, NEST_ADDRESS, NEST_AMOUNT_MINING);\n', '\n', '    \t// 二:转移NN未领取的NEST\n', '    \tuint256 NN_NestAmount = NestPool.getMinerNest(NNREWARDPOOL_ADDRESS);\n', '    \t// 2_1.更换NEST账本\n', '    \tNestPool.transferNestInPool(NNREWARDPOOL_ADDRESS, _owner, NN_NestAmount);\n', '    \t// 2_2.给管理员转账NEST\n', '    \tNestPool.withdrawToken(_owner, NEST_ADDRESS, NN_NestAmount);\n', '\n', '    \t// 三:NHBTC转账\n', '    \tuint256 NHBTCAmount = NestPool.balanceOfTokenInPool(NHBTC_OWNER, NHBTC_ADDRESS);\n', '    \tNestPool.withdrawToken(NHBTC_OWNER, NHBTC_ADDRESS, NHBTCAmount);\n', '\n', '    \t// 四:恢复地址\n', '    \tNestPool.setContracts(address(0x0), NEST_MINING_ADDRESS, address(0x0), address(0x0), address(0x0), address(0x0), address(0x0), address(0x0));\n', '\n', '    \t// 五:恢复3.5管理员\n', '    \tsetGov35();\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == _owner);\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '// 3.5矿池合约\n', 'interface INestPool {\n', '    // 设置管理员\n', '    function setGovernance(address _gov) external;\n', '    // 设置地址\n', '    function setContracts(\n', '            address NestToken, address NestMining, \n', '            address NestStaking, address NTokenController, \n', '            address NNToken, address NNRewardPool, \n', '            address NestQuery, address NestDAO\n', '        ) external;\n', '    // 转移nest账本\n', '    function transferNestInPool(address from, address to, uint256 amount) external;\n', '    // 转移ETH账本\n', '    function transferEthInPool(address from, address to, uint256 amount) external;\n', '    // 给矿工地址转账ETH和NEST\n', '    function withdrawEthAndToken(address miner, uint256 ethAmount, address token, uint256 tokenAmount) external;\n', '    // 转出Token\n', '    function withdrawToken(address miner, address token, uint256 tokenAmount) external;\n', '    // 查询NEST数量\n', '    function getMinerNest(address miner) external view returns (uint256 nestAmount);\n', '    // 查询其他token数量\n', '    function balanceOfTokenInPool(address miner, address token) external view returns (uint256);\n', '}']