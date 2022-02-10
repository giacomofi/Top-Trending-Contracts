['pragma solidity >=0.4.23 <0.6.0;\n', '\n', 'contract Fast3Matrix{\n', '    struct User {\n', '        uint id;\n', '        address referrer;\n', '        bool block;\n', '        uint8 partnercount;\n', '        uint8 level;\n', '        uint8 levelallw;\n', '        mapping(uint8 => address[]) partners;\n', '        mapping(uint8 => uint[]) D5No;\n', '       \n', '    }\n', '    \n', '    \n', '    uint8[6] private referrallevel = [\n', '       10,2,2,2,2,2\n', '    ];\n', '    \n', '    uint[] private L5Matrix;\n', '    \n', '    mapping(address => User) public users;\n', '    mapping(uint => address) public userIds;\n', '    mapping(address => uint) public balances; \n', '    \n', '    uint public lastUserId = 2;\n', '    uint private benid = 1;\n', '    uint8 private seqid = 0;\n', '    address public owner;\n', '    \n', '    event payout(address indexed sender,address indexed receiver,uint indexed dividend,uint8 matrix,uint8 level,uint8 position);\n', '    event Reentry(address indexed sender,uint senderid,uint8 level,uint8 status);\n', '    event Testor(uint benid,uint8 seqid,uint8 status);\n', '\n', '   \n', '    \n', '    constructor(address ownerAddress) public {\n', '        \n', '        owner = ownerAddress;\n', '        User memory user = User({\n', '            id: 1,\n', '            referrer: address(0),\n', '            partnercount : 0,\n', '          //  partners: address(0),\n', '            block: false,\n', '            levelallw:1,\n', '            level : 1\n', '        });\n', '        seqid = 1;\n', '        users[ownerAddress] = user;\n', '        userIds[1] = ownerAddress;\n', '        users[ownerAddress].D5No[0].push(1);\n', '        L5Matrix.push(1);\n', '        L5Matrix.push(1);\n', '    }\n', '    \n', '    function() external payable {\n', '        if(msg.data.length == 0) {\n', '            return registration(msg.sender, owner,msg.value);\n', '        }\n', '        \n', '        registration(msg.sender, bytesToAddress(msg.data),msg.value);\n', '    }\n', '\n', '    function registrationExt(address referrerAddress) external payable {\n', '       registration(msg.sender, referrerAddress,msg.value);\n', '    }\n', '    \n', '    function addtoMatrix(uint newseqid,uint8 status) private{\n', '        uint newid = uint(L5Matrix.length);\n', '        newid = newid + 1;\n', '        users[userIds[newseqid]].level++;\n', '        users[userIds[newseqid]].D5No[0].push(newid);\n', '        L5Matrix.push(newseqid);\n', '        emit Reentry(userIds[newseqid],newid,users[userIds[newseqid]].level,status);\n', '     }\n', '    \n', '    function registration(address userAddress, address referrerAddress,uint buyvalue) private {\n', '        require(msg.value == 0.25 ether, "registration cost 0.25");\n', '        require(!isUserExists(userAddress), "user exists");\n', '        require(isUserExists(referrerAddress), "referrer not exists");\n', '        \n', '        uint32 size;\n', '        assembly {\n', '            size := extcodesize(userAddress)\n', '        }\n', '        require(size == 0, "cannot be a contract");\n', '        \n', '        User memory user = User({\n', '            id: lastUserId,\n', '            referrer: referrerAddress,\n', '            partnercount :0,\n', '            block: false,\n', '            levelallw:1,\n', '            level : 0\n', '        });\n', '        \n', '        users[userAddress] = user;\n', '        users[userAddress].referrer = referrerAddress;\n', '        userIds[lastUserId] = userAddress;\n', '        \n', '        users[referrerAddress].partners[0].push(userAddress);\n', '        users[referrerAddress].partnercount++;\n', '        users[referrerAddress].levelallw = users[referrerAddress].levelallw + 2;\n', '        addtoMatrix(lastUserId,1);\n', '        lastUserId++;\n', '        levelreward(userAddress,referrerAddress,buyvalue);\n', '        findbenid(userAddress,buyvalue);\n', '    }\n', '\n', '    function levelreward(address userAddress,address referrerAddress,uint buyvalue) private{\n', '        uint8 count = 1;\n', '        uint dividend;\n', '        while(count < 7){\n', '            dividend = referrallevel[count-1] * buyvalue / 100;\n', '            if (referrerAddress != owner) {\n', '                emit payout(userAddress,referrerAddress,dividend,2,0,count);\n', '                sendreward(referrerAddress,dividend);\n', '                referrerAddress = users[referrerAddress].referrer;\n', '            }else{\n', '                emit payout(userAddress,owner,dividend,2,0,count);\n', '                sendreward(owner,dividend); \n', '            }\n', '            count++;\n', '        }\n', '    \n', '    }\n', '    \n', '    function findbenid(address userAddress,uint buyvalue) private {\n', '        uint dividend = 80 * buyvalue / 100;\n', '       address reinvest = userAddress;\n', '        if(seqid == 3){\n', '            //users[userIds[newseqid]].level;\n', '            emit payout(userAddress,userIds[L5Matrix[benid]],0,1,users[userIds[L5Matrix[benid]]].level,seqid);\n', '            addtoMatrix(L5Matrix[benid],2);\n', '            reinvest = userIds[L5Matrix[benid]];\n', '            benid = findqualifier(benid,userAddress);\n', '            seqid = 1;\n', '        }\n', '            emit payout(reinvest,userIds[L5Matrix[benid]],dividend,1,users[userIds[L5Matrix[benid]]].level,seqid);\n', '        sendreward(userIds[L5Matrix[benid]],dividend);\n', '        seqid++;\n', '     }\n', '      \n', '    function findqualifier(uint newseqid,address userAddress) internal returns(uint) {\n', '        uint newbenid = 0;\n', '        while (newbenid == 0) {\n', '            newseqid++;\n', '            if (users[userIds[L5Matrix[newseqid]]].level <= users[userIds[L5Matrix[newseqid]]].levelallw) {\n', '                newbenid = newseqid;\n', '            }else{\n', '                users[userIds[L5Matrix[newseqid]]].block = true;\n', '                emit Reentry(userAddress,newseqid,users[userIds[L5Matrix[newseqid]]].level,3);\n', '            }\n', '        }\n', '        return newseqid;\n', '    }\n', '    \n', '    function isUserExists(address user) public view returns (bool) {\n', '        return (users[user].id != 0);\n', '    }\n', '    \n', '    function usersD5Matrix(address userAddress) public view returns(uint, uint[] memory) {\n', '        return (L5Matrix.length,users[userAddress].D5No[0]);\n', '    }\n', '    \n', '    function userspartner(address userAddress) public view returns(address[] memory) {\n', '        return (users[userAddress].partners[0]);\n', '    }\n', '    \n', '\n', '    function sendreward(address receiver,uint dividend) private {\n', '        \n', '        if (!address(uint160(receiver)).send(dividend)) {\n', '            return address(uint160(receiver)).transfer(address(this).balance);\n', '        }\n', '        \n', '    }\n', '    \n', '    function bytesToAddress(bytes memory bys) private pure returns (address addr) {\n', '        assembly {\n', '            addr := mload(add(bys, 20))\n', '        }\n', '    }\n', '}']