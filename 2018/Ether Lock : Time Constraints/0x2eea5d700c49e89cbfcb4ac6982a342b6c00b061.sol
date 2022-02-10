['pragma solidity ^0.4.7;\n', 'contract MobaBase {\n', '    address public owner = 0x0;\n', '    bool public isLock = false;\n', '    constructor ()  public  {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    event transferToOwnerEvent(uint256 price);\n', '    \n', '    modifier onlyOwner {\n', '        require(msg.sender == owner,"only owner can call this function");\n', '        _;\n', '    }\n', '    \n', '    modifier notLock {\n', '        require(isLock == false,"contract current is lock status");\n', '        _;\n', '    }\n', '    \n', '    modifier msgSendFilter() {\n', '        address addr = msg.sender;\n', '        uint size;\n', '        assembly { size := extcodesize(addr) }\n', '        require(size <= 0,"address must is not contract");\n', '        require(msg.sender == tx.origin, "msg.sender must equipt tx.origin");\n', '        _;\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '    \n', '    function transferToOwner()    \n', '    onlyOwner \n', '    msgSendFilter \n', '    public {\n', '        uint256 totalBalace = address(this).balance;\n', '        owner.transfer(totalBalace);\n', '        emit transferToOwnerEvent(totalBalace);\n', '    }\n', '    \n', '    function updateLock(bool b) onlyOwner public {\n', '        \n', '        require(isLock != b," updateLock new status == old status");\n', '        isLock = b;\n', '    }\n', '    \n', '   \n', '}\n', '\n', 'contract IRandomUtil{\n', '    function getRandom(bytes32 param) public returns (bytes32);\n', '}\n', '\n', 'contract RandomUtil{\n', '    \n', '    function getRandom(bytes32 param) public returns (bytes32){\n', '           bytes32 value = keccak256(abi.encodePacked((block.timestamp) + (block.difficulty) \n', '           +((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)) \n', '           +(block.gaslimit) +((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)) + (block.number)));\n', '           return value;\n', '    }\n', '}\n', '\n', 'contract IInviteData{\n', '    function GetAddressByName(bytes32 name) public view returns (address);\n', '}\n', 'contract IConfigData {\n', '   function getPrice() public view returns (uint256);\n', '   function getWinRate(uint8 winCount) public pure returns (uint);\n', '   function getOverRate(uint8 winCount) public pure returns (uint);\n', '   function getPumpRate() public view returns(uint8);\n', '   function getRandom(bytes32 param) public returns (bytes32);\n', '   function GetAddressByName(bytes32 name) public view returns (address);\n', '   function getInviteRate() public view returns (uint);\n', '   function loseHandler(address addr,uint8 wincount) public ;\n', '}\n', '\n', 'contract BRBasketballConfig is MobaBase {\n', '    \n', '   uint256 mPrice    = 10;\n', '   uint8 mPumpRate   = 10;\n', '   uint8 mInviteRate = 10;\n', '   uint8 mWinRate    = 50;\n', '   IRandomUtil public mRandomUtil;\n', '   IInviteData public mInviteData;\n', '   \n', '   constructor(address randomUtil,address inviteData) public {\n', '        mRandomUtil = IRandomUtil(randomUtil);\n', '        mInviteData = IInviteData(inviteData);\n', '   }\n', '   \n', '   function getPrice() public view returns (uint256) {\n', '       return mPrice;\n', '   }\n', ' \n', '   function getPumpRate() public view returns(uint8) {\n', '       return mPumpRate;\n', '   }\n', '   \n', '   function getWinRate(uint8 winCount) public view returns (uint8) {\n', '       return mWinRate;\n', '   }\n', '    \n', '   function getOverRate(uint8 winCount) public pure returns (uint) {\n', '       \n', '        if(winCount  <= 1) {\n', '            return 50;\n', '        }\n', '        if(winCount  <= 2) {\n', '            return 55;  \n', '        } \n', '        if(winCount  <= 3) {\n', '            return 60;  \n', '        } \n', '        if(winCount  <= 4) {\n', '            return 65;  \n', '        } \n', '        if(winCount  <= 5) {\n', '            return 70;  \n', '        } \n', '        if(winCount  <= 6) {\n', '            return 75;  \n', '        } \n', '        return 80;  \n', '   }\n', '   \n', '   function getRandom(bytes32 param) public returns (bytes32) {\n', '       return mRandomUtil.getRandom(param);\n', '   }\n', '   function GetAddressByName(bytes32 name) public view returns (address) {\n', '       if(mInviteData != address(0)) {\n', '            return mInviteData.GetAddressByName(name);\n', '       }\n', '   }\n', '   function getInviteRate() public view returns (uint) {\n', '       return mInviteRate;\n', '   }\n', '   \n', '   function loseHandler(address addr,uint8 wincount) public {}\n', '}']