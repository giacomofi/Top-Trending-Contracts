['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "./ERC20.sol";\n', 'import "./KtlyoStaking.sol";\n', '\n', '\n', 'contract KtlyoStakingFactory {\n', ' \n', '    mapping(address => address[]) stakingPairs;\n', '\tuint256 ktlyoFee = 10000000000000000000;\n', '\taddress owner;\n', '\t\n', '\t\n', '\tconstructor() {\n', '\t\towner = msg.sender;\n', '\t}\n', '\t\n', '\tmodifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\tfunction getStakingPairs(address _user) \n', '        public\n', '        view\n', '        returns(address[] memory)\n', '    {\n', '        return stakingPairs[_user];\n', '    }\n', '\t\n', '\tfunction getKtlyoFee() \n', '        public\n', '        view\n', '        returns(uint256)\n', '    {\n', '        return ktlyoFee;\n', '    }\n', '\t\n', '\tfunction setKtlyoFee(uint256 _newFee) \n', '        public \n', '        onlyOwner \n', '        returns(uint256)\n', '    {\n', '        ktlyoFee = _newFee;\n', '\t\treturn ktlyoFee;\n', '    }\n', '\t\n', '\tfunction collectKtlyoFee(address _tokenFee) \n', '        public \n', '        onlyOwner \n', '        returns(bool)\n', '    {\n', '        ERC20 ktlyoToken = ERC20(_tokenFee);\n', '\t\tuint256 ktlyoBal = ktlyoToken.balanceOf(address(this));\n', '\t\trequire(ktlyoBal>0,"Fee balance is 0!");\n', '\t\tktlyoToken.transfer(msg.sender,ktlyoBal);\n', '\t\treturn true;\n', '    }\n', '\t\n', '\t\n', '    function newKtlyoStaking(address _token1, address _token2, uint256 _apy, uint256 _duration, uint256 _tokenRatio, uint256 _maxStakeAmt1, uint256 _rewardAmt1,address _tokenFee)\n', '        public\n', '        returns(address addressKsPair)\n', '    {\n', '\t\tERC20 ktlyoToken = ERC20(_tokenFee);\n', '        require(ktlyoToken.transferFrom(msg.sender, address(this), ktlyoFee),"Payment of fee not approved!");\n', '\t\t\n', '\t\t// Create new staking pair.\n', '        KtlyoStaking ksPair = new KtlyoStaking(_token1,_token2,_apy,_duration,_tokenRatio,_maxStakeAmt1,_rewardAmt1,msg.sender);\n', '        \n', '\t\taddressKsPair = address(ksPair);\n', '\t\t//address payable addressPayKsPair = payable(addressKsPair);\n', '\t\t\n', "        // Add wallet to sender's stakingPairs.\n", '        stakingPairs[msg.sender].push(addressKsPair);\n', '\n', '        // Send ether from this transaction to the created contract.\n', '\t\t//addressPayKsPair.transfer(msg.value);\n', '\t\t\n', '\n', '        // Emit event.\n', '        emit Created(addressKsPair, msg.sender, _token1,_token2,_apy,_duration, block.timestamp);\n', '    }\n', '\n', '    // Prevents accidental sending of ether to the factory\n', '    fallback () external {\n', '\t\t\n', '\t\trevert("ETH is not accepted");\n', '    }\n', '\t\n', '\t// return ETH\n', '    receive() external payable {\n', '\t\t\n', '        emit Reverted(msg.sender, msg.value);\n', '\t\trevert("ETH is not accepted");\n', '    }\n', '\t\n', '\n', '    event Created(address addressKsPair, address from, address token1,address token2, uint256 apy, uint256 duration, uint256 createdAt);\n', '\tevent Reverted(address from, uint256 amount);\n', '}']