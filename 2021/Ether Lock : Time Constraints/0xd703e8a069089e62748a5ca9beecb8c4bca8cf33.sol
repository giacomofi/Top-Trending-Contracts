['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-16\n', '*/\n', '\n', '// SPDX-License-Identifier: GPL-3.0\n', '\n', 'pragma solidity 0.7.4;\n', '\n', 'library ErrorCode {\n', '\n', "    string constant FORBIDDEN = 'YouSwap:FORBIDDEN';\n", "    string constant IDENTICAL_ADDRESSES = 'YouSwap:IDENTICAL_ADDRESSES';\n", "    string constant ZERO_ADDRESS = 'YouSwap:ZERO_ADDRESS';\n", "    string constant INVALID_ADDRESSES = 'YouSwap:INVALID_ADDRESSES';\n", "    string constant BALANCE_INSUFFICIENT = 'YouSwap:BALANCE_INSUFFICIENT';\n", "    string constant REWARDTOTAL_LESS_THAN_REWARDPROVIDE = 'YouSwap:REWARDTOTAL_LESS_THAN_REWARDPROVIDE';\n", "    string constant PARAMETER_TOO_LONG = 'YouSwap:PARAMETER_TOO_LONG';\n", "    string constant REGISTERED = 'YouSwap:REGISTERED';\n", '\n', '}\n', '\n', 'interface IYouswapInviteV1 {\n', '\n', '    struct UserInfo {\n', '        address up;//上级\n', '        address[] down;//下级\n', '        uint256 startBlock;//邀请块高\n', '    }\n', '\n', '    event InviteV1(address indexed owner, address indexed upper, uint256 indexed height);//被邀请人的地址，邀请人的地址，邀请块高\n', '\n', '    function inviteLength() external view returns (uint256);//邀请人数\n', '\n', '    function inviteUp1(address) external view returns (address);//上级邀请\n', '\n', '    function inviteUp2(address) external view returns (address, address);//上级邀请\n', '\n', '    function inviteDown1(address) external view returns (address[] memory);//下级邀请\n', '\n', '    function inviteDown2(address) external view returns (address[] memory, address[] memory);//下级邀请\n', '\n', '    function inviteDown2Count(address) external view returns (uint256, uint256);//下级邀请\n', '    \n', '    function register() external returns (bool);//注册邀请关系\n', '\n', '    function invite(address) external returns (bool);//注册邀请关系\n', '    \n', '    function inviteBatch(address[] memory) external returns (uint, uint);//注册邀请关系，输入数量，成功数量\n', '\n', '}\n', '\n', 'contract YouswapInviteV1 is IYouswapInviteV1 {\n', '\n', '    address public constant zero = address(0);\n', '    uint256 public startBlock;\n', '    address[] public inviteUserInfoV1;\n', '    mapping(address => UserInfo) public inviteUserInfoV2;\n', '\n', '    constructor () {\n', '        startBlock = block.number;\n', '    }\n', '    \n', '    function inviteLength() override external view returns (uint256) {\n', '        return inviteUserInfoV1.length;\n', '    }\n', '\n', '    function inviteUp1(address _address) override external view returns (address) {\n', '        return inviteUserInfoV2[_address].up;\n', '    }\n', '\n', '    function inviteUp2(address _address) override external view returns (address, address) {\n', '        address up1 = inviteUserInfoV2[_address].up;\n', '        address up2 = address(0);\n', '        if (address(0) != up1) {\n', '            up2 = inviteUserInfoV2[up1].up;\n', '        }\n', '\n', '        return (up1, up2);\n', '    }\n', '\n', '    function inviteDown1(address _address) override external view returns (address[] memory) {\n', '        return inviteUserInfoV2[_address].down;\n', '    }\n', '\n', '    function inviteDown2(address _address) override external view returns (address[] memory, address[] memory) {\n', '        address[] memory invite1 = inviteUserInfoV2[_address].down;\n', '        uint256 count = 0;\n', '        uint256 len = invite1.length;\n', '        for (uint256 i = 0; i < len; i++) {\n', '            count += inviteUserInfoV2[invite1[i]].down.length;\n', '        }\n', '        address[] memory down;\n', '        address[] memory invite2 = new address[](count);\n', '        count = 0;\n', '        for (uint256 i = 0; i < len; i++) {\n', '            down = inviteUserInfoV2[invite1[i]].down;\n', '            for (uint256 j = 0; j < down.length; j++) {\n', '                invite2[count] = down[j];\n', '                count++;\n', '            }\n', '        }\n', '        \n', '        return (invite1, invite2);\n', '    }\n', '\n', '    function inviteDown2Count(address _address) override external view returns (uint256, uint256) {\n', '        address[] memory invite1 = inviteUserInfoV2[_address].down;\n', '        uint256 invite2 = 0;\n', '        uint256 len = invite1.length;\n', '        for (uint256 i = 0; i < len; i++) {\n', '            invite2 += inviteUserInfoV2[invite1[i]].down.length;\n', '        }\n', '        \n', '        return (invite1.length, invite2);\n', '    }\n', '\n', '    function register() override external returns (bool) {\n', '        UserInfo storage user = inviteUserInfoV2[tx.origin];\n', '        require(0 == user.startBlock, ErrorCode.REGISTERED);\n', '        user.up = zero;\n', '        user.startBlock = block.number;\n', '        inviteUserInfoV1.push(tx.origin);\n', '        \n', '        emit InviteV1(tx.origin, user.up, user.startBlock);\n', '        \n', '        return true;\n', '    }\n', '\n', '    function invite(address _address) override external returns (bool) {\n', '        require(msg.sender != _address, ErrorCode.FORBIDDEN);\n', '        UserInfo storage user = inviteUserInfoV2[msg.sender];\n', '        require(0 == user.startBlock, ErrorCode.REGISTERED);\n', '        UserInfo storage up = inviteUserInfoV2[_address];\n', '        if (0 == up.startBlock) {\n', '            user.up = zero;\n', '        }else {\n', '            user.up = _address;\n', '            up.down.push(msg.sender);\n', '        }\n', '        user.startBlock = block.number;\n', '        inviteUserInfoV1.push(msg.sender);\n', '        \n', '        emit InviteV1(msg.sender, user.up, user.startBlock);\n', '\n', '        return true;\n', '    }\n', '\n', '    function inviteBatch(address[] memory _addresss) override external returns (uint, uint) {\n', '        uint len = _addresss.length;\n', '        require(len <= 100, ErrorCode.PARAMETER_TOO_LONG);\n', '        UserInfo storage user = inviteUserInfoV2[msg.sender];\n', '        if (0 == user.startBlock) {\n', '            user.up = zero;\n', '            user.startBlock = block.number;\n', '            inviteUserInfoV1.push(msg.sender);\n', '                        \n', '            emit InviteV1(msg.sender, user.up, user.startBlock);\n', '        }\n', '        uint count = 0;\n', '        for (uint i = 0; i < len; i++) {\n', '            if ((address(0) != _addresss[i]) && (msg.sender != _addresss[i])) {\n', '                UserInfo storage down = inviteUserInfoV2[_addresss[i]];\n', '                if (0 == down.startBlock) {\n', '                    down.up = msg.sender;\n', '                    down.startBlock = block.number;\n', '                    user.down.push(_addresss[i]);\n', '                    inviteUserInfoV1.push(_addresss[i]);\n', '                    count++;\n', '\n', '                    emit InviteV1(_addresss[i], msg.sender, down.startBlock);\n', '                }\n', '            }\n', '        }\n', '\n', '        return (len, count);\n', '    }\n', '\n', '}']