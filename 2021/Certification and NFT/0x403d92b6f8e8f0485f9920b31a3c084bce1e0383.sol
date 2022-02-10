['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-27\n', '*/\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', 'pragma solidity 0.8.3;\n', '\n', 'contract NestInfo36 {\n', '    \n', '    // Nest锁仓合约\n', '    address public nestStaking = 0xaA7A74a46EFE0C58FBfDf5c43Da30216a8aa84eC;\n', '    // Nest回售\n', '    address public nestRedeeming = 0xF48D58649dDb13E6e29e03059Ea518741169ceC8;\n', '    // 手续费账本\n', '    address public nestLedger = 0x34B931C7e5Dc45dDc9098A1f588A0EA0dA45025D;\n', '    // 投票合约 \n', '    address public nestVote = 0xDa52f53a5bE4cb876DE79DcfF16F34B95e2D38e9;\n', '    // nest地址\n', '    address public nest = 0x04abEdA201850aC0124161F037Efd70c74ddC74C;\n', '    // 价格数据合约\n', '    address public nestPriceFacade = 0xB5D2890c061c321A5B6A4a4254bb1522425BAF0A;\n', '    // 管理员\n', '    address public governance;\n', '    \n', '    // Proposal\n', '    struct DataView {\n', '\n', '        // Index of proposal\n', '        uint index;\n', '        \n', '        // The immutable field and the variable field are stored separately\n', '        /* ========== Immutable field ========== */\n', '\n', '        // The contract address which will be executed when the proposal is approved. (Must implemented IVotePropose)\n', '        address contractAddress;\n', '\n', '        // Voting start time\n', '        uint48 startTime;\n', '\n', '        // Voting stop time\n', '        uint48 stopTime;\n', '\n', '        // Proposer\n', '        address proposer;\n', '\n', '        // Staked nest amount\n', '        uint96 staked;\n', '\n', '        /* ========== Mutable field ========== */\n', '\n', '        // Gained value\n', '        // The maximum value of uint96 can be expressed as 79228162514264337593543950335, which is more than the total \n', '        // number of nest 10000000000 ether. Therefore, uint96 can be used to express the total number of votes\n', '        uint96 gainValue;\n', '\n', '        // The state of this proposal\n', '        uint32 state;  // 0: proposed | 1: accepted | 2: cancelled\n', '\n', '        // The executor of this proposal\n', '        address executor;\n', '\n', '        // The execution time (if any, such as block number or time stamp) is placed in the contract and is limited by the contract itself\n', '\n', '        // Circulation of nest\n', '        uint96 nestCirculation;\n', '    }\n', '    \n', '    constructor() public{\n', '        governance = msg.sender;\n', '    }\n', '    \n', '    //---------modifier---------\n', '    \n', '    modifier onlyGovernance() {\n', '        require(msg.sender == governance);\n', '        _;\n', '    }\n', '    \n', '    //---------governance-------\n', '    \n', '    function setNestStaking(address add) external onlyGovernance {\n', '        require(add != address(0x0));\n', '        nestStaking = add;\n', '    }\n', '    \n', '    function setNestRedeeming(address add) external onlyGovernance {\n', '        require(add != address(0x0));\n', '        nestRedeeming = add;\n', '    }\n', '    \n', '    function setNestLedger(address add) external onlyGovernance {\n', '        require(add != address(0x0));\n', '        nestLedger = add;\n', '    }\n', '    \n', '    function setNestVote(address add) external onlyGovernance {\n', '        require(add != address(0x0));\n', '        nestVote = add;\n', '    }\n', '    \n', '    function setNest(address add) external onlyGovernance {\n', '        require(add != address(0x0));\n', '        nest = add;\n', '    }\n', '    \n', '    function setNestPriceFacade(address add) external onlyGovernance {\n', '        require(add != address(0x0));\n', '        nestPriceFacade = add;\n', '    }\n', '    \n', '    //---------view-------------\n', '    \n', '    /**\n', '    * @dev 收益页面信息\n', '    * @param nToken 查询的ntoken或nest地址\n', '    * @return accountStaked 账户锁仓量\n', '    * @return accountEarned 账户可领取收益\n', '    */\n', '    function getStakingInfo(address nToken) external view returns (uint256 accountStaked, uint256 accountEarned) {\n', '        INestStaking C_NestStake = INestStaking(address(nestStaking));\n', '        accountStaked = C_NestStake.stakedBalanceOf(nToken, address(msg.sender));\n', '        accountEarned = C_NestStake.earned(nToken, address(msg.sender));\n', '    }\n', '    \n', '    /**\n', '    * @dev 回售页面信息\n', '    * @param nToken 查询的ntoken或nest地址\n', '    * @param tokenAmount 价值 1 ETH 的 ntoken 数量\n', '    * @return resolvableAmount 可回购数量\n', '    * @return priceAmount 当前价格\n', '    * @return totalAmount 已锁定总量 \n', '    * @return tokenBalance token余额\n', '    * @return tokenAllow token授权额度\n', '    * @return tokenTotal token流通量\n', '    * @return nestIn01 nest销毁额度\n', '    */\n', '    function getRedeemingInfo(address nToken, uint256 tokenAmount) external view returns(uint256 resolvableAmount, \n', '                                                                                         uint256 priceAmount, \n', '                                                                                         uint256 totalAmount,\n', '                                                                                         uint256 tokenBalance, \n', '                                                                                         uint256 tokenAllow,\n', '                                                                                         uint256 tokenTotal,\n', '                                                                                         uint256 nestIn01,\n', '                                                                                         uint256 fee) {\n', '        uint256 ethBalance = INestLedger(address(nestLedger)).totalRewards(nToken);\n', '        uint256 ethResolvable = tokenAmount * ethBalance / uint256(1 ether);\n', '        uint256 realResolvable = INestRedeeming(nestRedeeming).quotaOf(nToken);\n', '        if (ethResolvable < realResolvable) {\n', '            resolvableAmount = ethResolvable;\n', '        } else {\n', '            resolvableAmount = realResolvable;\n', '        }\n', '        priceAmount = tokenAmount;\n', '        totalAmount = IERC20(nToken).balanceOf(address(nestLedger));                                                                                     \n', '        tokenBalance = IERC20(nToken).balanceOf(address(msg.sender));\n', '        tokenAllow = IERC20(nToken).allowance(address(msg.sender), address(nestRedeeming));\n', '        if (nToken == nest) {\n', '            tokenTotal = INestVote(nestVote).getNestCirculation();\n', '        } else {\n', '            tokenTotal = IERC20(nToken).totalSupply() - IERC20(nToken).balanceOf(address(nestLedger));\n', '        }\n', '        nestIn01 = IERC20(nest).balanceOf(address(0x0000000000000000000000000000000000000001));\n', '        INestPriceFacade.Config memory info = INestPriceFacade(nestPriceFacade).getConfig();\n', '        // fee = info.singleFee * 0.0001 ether;\n', '        fee = uint256(info.singleFee) * 0.0001 ether;\n', '    }\n', '    \n', '    /**\n', '    * @dev token余额授权信息\n', '    * @param token 查询的token\n', '    * @param to 授权目标\n', '    * @return balanceAmount 钱包余额\n', '    * @return allowAmount 授权额度\n', '    */\n', '    function balanceAndAllow(address token, address to) external view returns(uint256 balanceAmount, uint256 allowAmount) {\n', '        balanceAmount = IERC20(address(token)).balanceOf(address(msg.sender));\n', '        allowAmount = IERC20(address(token)).allowance(address(msg.sender), address(to));\n', '    }\n', '    \n', '    \n', '    function list(uint offset, uint count, uint order) public view returns (DataView[] memory) {\n', '        INestVote.ProposalView[] memory data = INestVote(nestVote).list(offset, count, order);\n', '        DataView[] memory returnData = new DataView[](data.length);\n', '        for (uint256 i = 0; i < data.length; i++) {\n', '            INestVote.ProposalView memory vote = data[i];\n', '            DataView memory info = DataView(vote.index, vote.contractAddress, vote.startTime, vote.stopTime, vote.proposer, vote.staked, vote.gainValue, vote.state, vote.executor, vote.nestCirculation);\n', '            returnData[i] = info;\n', '        }\n', '        return returnData;\n', '    }\n', '}\n', '\n', '\n', 'interface INestStaking {\n', '\n', '    function totalStaked(address ntoken) external view returns (uint256);\n', '\n', '    function stakedBalanceOf(address ntoken, address account) external view returns (uint256);\n', '    \n', '    function totalRewards(address ntoken) external view returns (uint256);\n', '    \n', '    function earned(address ntoken, address account) external view returns (uint256);\n', '}\n', '\n', 'interface IERC20 {\n', '    \n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    \n', '}\n', '\n', 'interface INestRedeeming {\n', '    function quotaOf(address ntokenAddress) external view returns (uint);\n', '}\n', '\n', 'interface INestLedger {\n', '    function totalRewards(address ntokenAddress) external view returns (uint);\n', '}\n', '\n', 'interface INestVote {\n', '    // Proposal\n', '    struct ProposalView {\n', '\n', '        // Index of proposal\n', '        uint index;\n', '        \n', '        // The immutable field and the variable field are stored separately\n', '        /* ========== Immutable field ========== */\n', '\n', '        // Brief of this proposal\n', '        string brief;\n', '\n', '        // The contract address which will be executed when the proposal is approved. (Must implemented IVotePropose)\n', '        address contractAddress;\n', '\n', '        // Voting start time\n', '        uint48 startTime;\n', '\n', '        // Voting stop time\n', '        uint48 stopTime;\n', '\n', '        // Proposer\n', '        address proposer;\n', '\n', '        // Staked nest amount\n', '        uint96 staked;\n', '\n', '        /* ========== Mutable field ========== */\n', '\n', '        // Gained value\n', '        // The maximum value of uint96 can be expressed as 79228162514264337593543950335, which is more than the total \n', '        // number of nest 10000000000 ether. Therefore, uint96 can be used to express the total number of votes\n', '        uint96 gainValue;\n', '\n', '        // The state of this proposal\n', '        uint32 state;  // 0: proposed | 1: accepted | 2: cancelled\n', '\n', '        // The executor of this proposal\n', '        address executor;\n', '\n', '        // The execution time (if any, such as block number or time stamp) is placed in the contract and is limited by the contract itself\n', '\n', '        // Circulation of nest\n', '        uint96 nestCirculation;\n', '    }\n', '    function getNestCirculation() external view returns (uint);\n', '    function list(uint offset, uint count, uint order) external view returns (ProposalView[] memory);\n', '}\n', '\n', 'interface INestPriceFacade {\n', '    \n', '    /// @dev Price call entry configuration structure\n', '    struct Config {\n', '\n', '        // Single query fee（0.0001 ether, DIMI_ETHER). 100\n', '        uint16 singleFee;\n', '\n', '        // Double query fee（0.0001 ether, DIMI_ETHER). 100\n', '        uint16 doubleFee;\n', '\n', '        // The normal state flag of the call address. 0\n', '        uint8 normalFlag;\n', '    }\n', '    function getConfig() external view returns (Config memory);\n', '    \n', '}']