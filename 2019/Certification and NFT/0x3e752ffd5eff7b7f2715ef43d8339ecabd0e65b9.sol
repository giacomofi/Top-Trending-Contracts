['pragma solidity ^0.4.25;\n', '\n', 'interface Snip3DInterface  {\n', '    function() payable external;\n', '   function offerAsSacrifice(address MN)\n', '        external\n', '        payable\n', '        ;\n', '         function withdraw()\n', '        external\n', '        ;\n', '        function myEarnings()\n', '        external\n', '        view\n', '       \n', '        returns(uint256);\n', '        function tryFinalizeStage()\n', '        external;\n', '    function sendInSoldier(address masternode) external payable;\n', '    function fetchdivs(address toupdate) external;\n', '    function shootSemiRandom() external;\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '    \n', '}\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '// Snip3dbridge contract\n', 'contract Slaughter3D is  Owned {\n', '    using SafeMath for uint;\n', '    Snip3DInterface constant Snip3Dcontract_ = Snip3DInterface(0xb172BB8BAae74F27Ade3211E0c145388d3b4f8d8);// change to real address\n', '    uint256 public toSlaughter;\n', '    function harvestableBalance()\n', '        view\n', '        public\n', '        returns(uint256)\n', '    {\n', '        uint256 toReturn = address(this).balance.sub(toSlaughter);\n', '        return ( toReturn)  ;\n', '    }\n', '    function unfetchedVault()\n', '        view\n', '        public\n', '        returns(uint256)\n', '    {\n', '        return ( Snip3Dcontract_.myEarnings())  ;\n', '    }\n', '    function sacUp ()  public payable {\n', '       \n', '        toSlaughter = toSlaughter.add(msg.value);\n', '    }\n', '    function sacUpto (address masternode)  public {\n', '        require(toSlaughter> 0.1 ether);\n', '        toSlaughter = toSlaughter.sub(0.1 ether);\n', '        Snip3Dcontract_.offerAsSacrifice.value(0.1 ether)(masternode);\n', '    }\n', '    function validate ()  public {\n', '       \n', '        Snip3Dcontract_.tryFinalizeStage();\n', '    }\n', '    function fetchvault () public {\n', '      \n', '        Snip3Dcontract_.withdraw();\n', '    }\n', '    function fetchBalance () onlyOwner public {\n', '      uint256 tosend = address(this).balance.sub(toSlaughter);\n', '        msg.sender.transfer(tosend);\n', '    }\n', '    function () external payable{} // needs for divs\n', '}']