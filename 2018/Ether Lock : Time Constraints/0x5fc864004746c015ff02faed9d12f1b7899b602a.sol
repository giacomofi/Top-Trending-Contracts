['pragma solidity ^0.4.24;\n', '\n', 'contract TransEther{\n', '    \n', '    //조건\n', '    //1. SmartContract 주소로 1이더를 받는 즉시  \n', '    //2 99.9% 내 지갑 주소로 전송 bossAddress : 0x40e899a8a0Ca7d1a79b6b1bb0f03AD090F0Ad747\n', '    //3. 나머지 0.1%는 특정 주소로 전송        otherAdderss : \n', '\n', '    address owener ;\n', '    address bossAddr =   0x40e899a8a0Ca7d1a79b6b1bb0f03AD090F0Ad747;     // 99.9% 받는 주소1 (주소 변경 시 이곳 수정)\n', '    address customAddr = 0xEc61C896C8F638e3970ed729E072f7AB03a10b5A;     // 0.1 받는 주소2   (주소 변경 시 이곳 수정)\n', '    mapping (address => uint) public balances;\n', '    \n', '    event EthValueLog(address from, uint vlaue,uint cur);\n', '    \n', '    constructor() public{\n', '        owener = msg.sender;\n', '    }\n', '    \n', '    function() payable public{\n', '        \n', '        uint value = msg.value; \n', '        require(msg.value > 0);\n', '        \n', '        uint firstValue = value * 999 / 1000;\n', '        uint secondValue = value * 1 / 1000;\n', '        \n', '        //bool sendok1 = msg.sender.call.value(firstValue).gas(21000)();\n', '        //bool sendok2 = msg.sender.call.value(secondValue).gas(21000)();\n', '        \n', '         bossAddr.transfer(firstValue);\n', '         emit EthValueLog(bossAddr,firstValue,now);\n', '         \n', '         customAddr.transfer(secondValue);\n', '         emit EthValueLog(customAddr,secondValue,now);\n', '        \n', '    } \n', '}']