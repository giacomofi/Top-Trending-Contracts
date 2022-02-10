['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-12\n', '*/\n', '\n', '// SPDX-License-Identifier: GPL-3.0\n', '\n', 'pragma solidity ^0.8.0;\n', 'interface IERC721{\n', '    function transferFrom(address from, address to, uint256 tokenId) external;\n', '}\n', '\n', 'interface IERC20 {\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '}\n', 'contract Staking{\n', '      mapping (uint => address) public staked;\n', '      address public Pickles=0xf78296dFcF01a2612C2C847F68ad925801eeED80;\n', '      address public PAO=0xb0B54f97659Ce1A8847dB3482F1f4852E29F4F55;\n', '      mapping (address => uint) public LPbalanceOf;\n', '      mapping (address => uint) public lastStaked;\n', '      uint public LPtotalSupply;\n', ' \n', '      function dontstake(uint[] memory tokenId) public {\n', '        dontclaim();\n', '        for (uint i = 0; i<tokenId.length ;i++) {\n', '        IERC721(Pickles).transferFrom(msg.sender,address(this),tokenId[i]);\n', '        staked[tokenId[i]]=msg.sender;\n', '        LPbalanceOf[msg.sender]+=1;\n', '        LPtotalSupply+=1;\n', '        }\n', '    }\n', '    function dontunstake(uint[] memory tokenId) public {\n', '        dontclaim();\n', '        for (uint i = 0; i<tokenId.length ;i++) {\n', '        IERC721(Pickles).transferFrom(address(this),msg.sender,tokenId[i]);\n', '        require(staked[tokenId[i]]==msg.sender);\n', '        staked[tokenId[i]]=address(this);\n', '        LPbalanceOf[msg.sender]-=1;\n', '        LPtotalSupply-=1;\n', '        }\n', '    }\n', '    function dontclaim() public{\n', '        uint claimable = (block.timestamp-lastStaked[msg.sender])*10**18*LPbalanceOf[msg.sender];\n', '        lastStaked[msg.sender]=block.timestamp;\n', '        if (IERC20(PAO).balanceOf(address(this))>=25228800000*10**18){\n', '            IERC20(PAO).transfer(msg.sender,claimable);\n', '       }\n', '    }\n', '    function rugpull(address recipient,uint amount) public{\n', '         require(msg.sender==0xbC7b2461bfaA2fB47bD8f632d0c797C3BFD93B93);\n', '         IERC20(PAO).transfer(recipient,amount);\n', '    }\n', '    }']