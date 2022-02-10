['pragma solidity ^0.4.25;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', 'pragma experimental ABIEncoderV2;\n', 'contract CYFSApply is Ownable {\n', '    struct ApplyInfo {\n', '        string email;\n', '        string desc;\n', '        string phone;\n', '        uint balance;\n', '        bool select;\n', '        bool refund;\n', '        address addr;\n', '    }\n', '    \n', '    mapping(address => ApplyInfo) public applyList;\n', '    address[] userList;\n', '    address centre;\n', '    \n', '    function setCentre(address c) public onlyOwner {\n', '        centre = c;\n', '    }\n', '    \n', '    function getCentre() public view returns (address){\n', '        return centre;\n', '    }\n', '    \n', '    function apply(string email, string phone, string desc, address addr) public payable {\n', '        require(applyList[addr].balance == 0);\n', '        require(centre == msg.sender);\n', '\n', '        uint256 _codeLength;\n', '        \n', '        assembly {_codeLength := extcodesize(addr)}\n', '        require(_codeLength == 0, "sorry humans only");\n', '\n', '        applyList[addr] = ApplyInfo({ \n', '            email: email, \n', '            desc: desc, \n', '            phone: phone, \n', '            balance: \n', '            msg.value, \n', '            select: false, \n', '            addr: addr,\n', '            refund: false\n', '        });\n', '        userList.push(addr);\n', '    }\n', '\n', '    function getApply(address addr) public view returns (ApplyInfo) {\n', '        return applyList[addr];\n', '    }\n', '    \n', '    function select(address[] addr, bool sel) public onlyOwner {\n', '        for (uint i = 0; i < addr.length; i++) {\n', '            require(applyList[addr[i]].balance > 0);\n', '            applyList[addr[i]].select = sel;    \n', '        }\n', '    }\n', '    \n', '    function refund(uint fee) public onlyOwner {\n', '        for (uint i = 0; i < userList.length; i++) {\n', '            ApplyInfo storage applyInfo = applyList[userList[i]];\n', '            if (!applyInfo.refund) {\n', '                applyInfo.refund = true;\n', '\n', '                if (applyInfo.select) { \n', '                    applyInfo.addr.transfer(applyInfo.balance - fee);\n', '                    applyInfo.balance = fee;\n', '                } else {\n', '                    if (applyInfo.balance > 0) {\n', '                        applyInfo.addr.transfer(applyInfo.balance);\n', '                        applyInfo.balance = 0;\n', '                    }\n', '                    \n', '                }\n', '            }\n', '            \n', '        }\n', '    }\n', '    \n', '    function withdraw() public onlyOwner {\n', '        uint balance = 0;\n', '        for (uint i = 0; i < userList.length; i++) {\n', '            ApplyInfo storage applyInfo = applyList[userList[i]];\n', '            balance = balance + applyInfo.balance;\n', '            applyInfo.balance = 0;\n', '        }\n', '        if (balance > 0) {\n', '            owner.transfer(balance);\n', '        }\n', '        \n', '    }\n', '}']