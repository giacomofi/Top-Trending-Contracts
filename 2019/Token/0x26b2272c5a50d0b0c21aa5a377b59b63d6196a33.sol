['pragma solidity ^0.4.16;\n', '\n', '//Base class of token-owner\n', 'contract Ownable {\n', "\taddress public owner;\t\t\t\t\t\t\t\t\t\t\t\t\t\t//owner's address\n", '\n', '\tfunction Ownable() public \n', '\t{\n', '\t\towner = msg.sender;\n', '\t}\n', '\n', '\tmodifier onlyOwner() {\n', '\t\trequire(msg.sender == owner);\n', '\t\t_;\n', '\t}\n', '\t/*\n', "\t*\tFuntion: Transfer owner's authority \n", '\t*\tType:Public and onlyOwner\n', '\t*\tParameters:\n', '\t\t\t@newOwner:\taddress of newOwner\n', '\t*/\n', '\tfunction transferOwnership(address newOwner) onlyOwner public{\n', '\t\tif (newOwner != address(0)) {\n', '\t\towner = newOwner;\n', '\t\t}\n', '\t}\n', '\t\n', '\tfunction kill() onlyOwner public{\n', '\t\tselfdestruct(owner);\n', '\t}\n', '}\n', '\n', '//Announcement of an interface for recipient approving\n', 'interface tokenRecipient { \n', '\tfunction receiveApproval(address _from, uint256 _value, address _token, bytes _extraData)public; \n', '}\n', '\n', '\n', 'contract CARTCRC20 is Ownable{\n', '\t\n', '\t//===================public variables definition start==================\n', '    string public name;\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t//Name of your Token\n', '    string public symbol;\t\t\t\t\t\t\t\t\t\t\t\t\t\t//Symbol of your Token\n', '    uint8 public decimals;\t\t\t\t\t\t\t\t\t\t\t\t\t\t//Decimals of your Token\n', '    uint256 public totalSupply;\t\t\t\t\t\t\t\t\t\t\t\t\t//Maximum amount of Token supplies\n', '\n', '    //define dictionaries of balance\n', "    mapping (address => uint256) public balanceOf;\t\t\t\t\t\t\t\t//Announce the dictionary of account's balance\n", "    mapping (address => mapping (address => uint256)) public allowance;\t\t\t//Announce the dictionary of account's available balance\n", '\t//===================public variables definition end==================\n', '\n', '\t\n', '\t//===================events definition start==================    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\t//Event on blockchain which notify client\n', '\t//===================events definition end==================\n', '\t\n', '\t\n', '\t//===================Contract Initialization Sequence Definition start===================\n', '    function CARTCRC20 () public {\n', "\t\tdecimals=8;\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t//Assignment of Token's decimals\n", "\t\ttotalSupply = 10000000000 * 10 ** uint256(decimals);  \t\t\t\t//Assignment of Token's total supply with decimals\n", "        balanceOf[owner] = totalSupply;                \t\t\t\t\t\t//Assignment of Token's creator initial tokens\n", '        name = "CARTC";                                   \t\t\t\t\t//Set the name of Token\n', '        symbol = "CARTC";                               \t\t\t\t\t\t//Set the symbol of  Token\n', '        \n', '    }\n', '\t//===================Contract Initialization Sequence definition end===================\n', '\t\n', '\t//===================Contract behavior & funtions definition start===================\n', '\t\n', '\t/*\n', '\t*\tFuntion: Transfer funtions\n', '\t*\tType:Internal\n', '\t*\tParameters:\n', "\t\t\t@_from:\taddress of sender's account\n", "\t\t\t@_to:\taddress of recipient's account\n", '\t\t\t@_value:transaction amount\n', '\t*/\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '\t\t//Fault-tolerant processing\n', '\t\trequire(_to != 0x0);\t\t\t\t\t\t//\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '\n', '        //Execute transaction\n', '\t\tuint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '\t\t\n', '\t\t//Verify transaction\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\t\n', '\t\n', '\t/*\n', '\t*\tFuntion: Transfer tokens\n', '\t*\tType:Public\n', '\t*\tParameters:\n', "\t\t\t@_to:\taddress of recipient's account\n", '\t\t\t@_value:transaction amount\n', '\t*/\n', '    function transfer(address _to, uint256 _value) public {\n', '\t\t\n', '        _transfer(msg.sender, _to, _value);\n', '    }\t\n', '\t\n', '\t/*\n', '\t*\tFuntion: Transfer tokens from other address\n', '\t*\tType:Public\n', '\t*\tParameters:\n', "\t\t\t@_from:\taddress of sender's account\n", "\t\t\t@_to:\taddress of recipient's account\n", '\t\t\t@_value:transaction amount\n', '\t*/\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public \n', '\treturns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     \t\t\t\t\t//Allowance verification\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '\t/*\n', '\t*\tFuntion: Approve usable amount for an account\n', '\t*\tType:Public\n', '\t*\tParameters:\n', "\t\t\t@_spender:\taddress of spender's account\n", '\t\t\t@_value:\tapprove amount\n', '\t*/\n', '    function approve(address _spender, uint256 _value) public \n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '        }\n', '\n', '\t/*\n', '\t*\tFuntion: Approve usable amount for other address and then notify the contract\n', '\t*\tType:Public\n', '\t*\tParameters:\n', '\t\t\t@_spender:\taddress of other account\n', '\t\t\t@_value:\tapprove amount\n', '\t\t\t@_extraData:additional information to send to the approved contract\n', '\t*/\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public \n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '    /*\n', "\t*\tFuntion: Transfer owner's authority and account balance\n", '\t*\tType:Public and onlyOwner\n', '\t*\tParameters:\n', '\t\t\t@newOwner:\taddress of newOwner\n', '\t*/\n', '    function transferOwnershipWithBalance(address newOwner) onlyOwner public{\n', '\t\tif (newOwner != address(0)) {\n', '\t\t    _transfer(owner,newOwner,balanceOf[owner]);\n', '\t\t    owner = newOwner;\n', '\t\t}\n', '\t}\n', '   //===================Contract behavior & funtions definition end===================\n', '}']