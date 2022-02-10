['pragma solidity ^0.4.24;\n', '\n', 'contract Nicks {\n', '  mapping (address => string) private nickOfOwner;\n', '  mapping (string => address) private ownerOfNick;\n', '\n', '  event Set (string indexed _nick, address indexed _owner);\n', '  event Unset (string indexed _nick, address indexed _owner);\n', '\n', '  constructor () public {\n', '\tcontractOwner = msg.sender;\n', '  }\n', '  \n', '  address public contractOwner; \n', '  \n', '\n', 'modifier onlyOwner() {\n', '\t\trequire(contractOwner == msg.sender);\n', '\t\t_;\n', '\t}\n', '\n', '\t\n', '  function nickOf (address _owner) public view returns (string _nick) {\n', '    return nickOfOwner[_owner];\n', '  }\n', '\n', '  function ownerOf (string _nick) public view returns (address _owner) {\n', '    return ownerOfNick[_nick];\n', '  }\n', '\n', '  function set (string _nick) public {\n', '    require(bytes(_nick).length > 2);\n', '    require(ownerOf(_nick) == address(0));\n', '\n', '    address owner = msg.sender;\n', '    string storage oldNick = nickOfOwner[owner];\n', '\n', '    if (bytes(oldNick).length > 0) {\n', '      emit Unset(oldNick, owner);\n', '      delete ownerOfNick[oldNick];\n', '    }\n', '\n', '    nickOfOwner[owner] = _nick;\n', '    ownerOfNick[_nick] = owner;\n', '    emit Set(_nick, owner);\n', '  }\n', '\n', '  function unset () public {\n', '    require(bytes(nickOfOwner[msg.sender]).length > 0);\n', '\n', '    address owner = msg.sender;\n', '    string storage oldNick = nickOfOwner[owner];\n', '\n', '    emit Unset(oldNick, owner);\n', '\n', '    delete ownerOfNick[oldNick];\n', '    delete nickOfOwner[owner];\n', '  }\n', '\n', '  \n', '  \n', '\n', '/////////////////////////////////\n', '/// USEFUL FUNCTIONS ///\n', '////////////////////////////////\n', '\n', '/* Fallback function to accept all ether sent directly to the contract */\n', '\n', '    function() payable public\n', '    {    }\n', '\t\n', '\t\n', '\tfunction withdrawEther() public onlyOwner {\n', '\t\trequire(address(this).balance > 0);\n', '\t\t\n', '        contractOwner.transfer(address(this).balance);\n', '    }\n', '\t\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract Nicks {\n', '  mapping (address => string) private nickOfOwner;\n', '  mapping (string => address) private ownerOfNick;\n', '\n', '  event Set (string indexed _nick, address indexed _owner);\n', '  event Unset (string indexed _nick, address indexed _owner);\n', '\n', '  constructor () public {\n', '\tcontractOwner = msg.sender;\n', '  }\n', '  \n', '  address public contractOwner; \n', '  \n', '\n', 'modifier onlyOwner() {\n', '\t\trequire(contractOwner == msg.sender);\n', '\t\t_;\n', '\t}\n', '\n', '\t\n', '  function nickOf (address _owner) public view returns (string _nick) {\n', '    return nickOfOwner[_owner];\n', '  }\n', '\n', '  function ownerOf (string _nick) public view returns (address _owner) {\n', '    return ownerOfNick[_nick];\n', '  }\n', '\n', '  function set (string _nick) public {\n', '    require(bytes(_nick).length > 2);\n', '    require(ownerOf(_nick) == address(0));\n', '\n', '    address owner = msg.sender;\n', '    string storage oldNick = nickOfOwner[owner];\n', '\n', '    if (bytes(oldNick).length > 0) {\n', '      emit Unset(oldNick, owner);\n', '      delete ownerOfNick[oldNick];\n', '    }\n', '\n', '    nickOfOwner[owner] = _nick;\n', '    ownerOfNick[_nick] = owner;\n', '    emit Set(_nick, owner);\n', '  }\n', '\n', '  function unset () public {\n', '    require(bytes(nickOfOwner[msg.sender]).length > 0);\n', '\n', '    address owner = msg.sender;\n', '    string storage oldNick = nickOfOwner[owner];\n', '\n', '    emit Unset(oldNick, owner);\n', '\n', '    delete ownerOfNick[oldNick];\n', '    delete nickOfOwner[owner];\n', '  }\n', '\n', '  \n', '  \n', '\n', '/////////////////////////////////\n', '/// USEFUL FUNCTIONS ///\n', '////////////////////////////////\n', '\n', '/* Fallback function to accept all ether sent directly to the contract */\n', '\n', '    function() payable public\n', '    {    }\n', '\t\n', '\t\n', '\tfunction withdrawEther() public onlyOwner {\n', '\t\trequire(address(this).balance > 0);\n', '\t\t\n', '        contractOwner.transfer(address(this).balance);\n', '    }\n', '\t\n', '}']