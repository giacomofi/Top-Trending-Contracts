['pragma solidity ^0.4.16;\n', '\n', '/*SPEND APPROVAL ALERT INTERFACE*/\n', 'interface tokenRecipient { \n', 'function receiveApproval(address _from, uint256 _value, \n', 'address _token, bytes _extraData) external; \n', '}\n', '\n', 'contract TOC {\n', '/*tokenchanger.io*/\n', '\n', '/*TOC TOKEN*/\n', 'string public name;\n', 'string public symbol;\n', 'uint8 public decimals;\n', 'uint256 public totalSupply;\n', '\n', '/*user coin balance*/\n', 'mapping (address => uint256) public balances;\n', '/*user coin allowances*/\n', 'mapping(address => mapping (address => uint256)) public allowed;\n', '\n', '/*EVENTS*/\t\t\n', '/*broadcast token transfers on the blockchain*/\n', 'event Transfer(address indexed from, address indexed to, uint256 value);\n', '/*broadcast token spend approvals on the blockchain*/\n', 'event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\n', '/*MINT TOKEN*/\n', 'function TOC() public {\n', 'name = "Token Changer";\n', 'symbol = "TOC";\n', 'decimals = 18;\n', '/*one billion base units*/\n', 'totalSupply = 10**27;\n', 'balances[msg.sender] = totalSupply; \n', '}\n', '\n', '/*INTERNAL TRANSFER*/\n', 'function _transfer(address _from, address _to, uint _value) internal {    \n', '/*prevent transfer to invalid address*/    \n', 'if(_to == 0x0) revert();\n', '/*check if the sender has enough value to send*/\n', 'if(balances[_from] < _value) revert(); \n', '/*check for overflows*/\n', 'if(balances[_to] + _value < balances[_to]) revert();\n', '/*compute sending and receiving balances before transfer*/\n', 'uint PreviousBalances = balances[_from] + balances[_to];\n', '/*substract from sender*/\n', 'balances[_from] -= _value;\n', '/*add to the recipient*/\n', 'balances[_to] += _value; \n', '/*check integrity of transfer operation*/\n', 'assert(balances[_from] + balances[_to] == PreviousBalances);\n', '/*broadcast transaction*/\n', 'emit Transfer(_from, _to, _value); \n', '}\n', '\n', '/*PUBLIC TRANSFERS*/\n', 'function transfer(address _to, uint256 _value) external returns (bool){\n', '_transfer(msg.sender, _to, _value);\n', 'return true;\n', '}\n', '\n', '/*APPROVE THIRD PARTY SPENDING*/\n', 'function approve(address _spender, uint256 _value) public returns (bool success){\n', '/*update allowance record*/    \n', 'allowed[msg.sender][_spender] = _value;\n', '/*broadcast approval*/\n', 'emit Approval(msg.sender, _spender, _value); \n', 'return true;                                        \n', '}\n', '\n', '/*THIRD PARTY TRANSFER*/\n', 'function transferFrom(address _from, address _to, uint256 _value) \n', 'external returns (bool success) {\n', '/*check if the message sender can spend*/\n', 'require(_value <= allowed[_from][msg.sender]); \n', '/*substract from message sender&#39;s spend allowance*/\n', 'allowed[_from][msg.sender] -= _value;\n', '/*transfer tokens*/\n', '_transfer(_from, _to, _value);\n', 'return true;\n', '}\n', '\n', '/*APPROVE SPEND ALLOWANCE AND CALL SPENDER*/\n', 'function approveAndCall(address _spender, uint256 _value, \n', ' bytes _extraData) external returns (bool success) {\n', 'tokenRecipient \n', 'spender = tokenRecipient(_spender);\n', 'if(approve(_spender, _value)) {\n', 'spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '}\n', 'return true;\n', '}\n', '\n', '/*INVALID TRANSACTIONS*/\n', 'function () payable external{\n', 'revert();  \n', '}\n', '\n', '}/////////////////////////////////end of toc token contract\n', '\n', 'pragma solidity ^0.4.22;\n', '\n', 'contract AirdropDIST {\n', '/*(c)2018 tokenchanger.io -all rights reserved*/\n', '\n', '/*SUPER ADMINS*/\n', 'address Mars = 0x1947f347B6ECf1C3D7e1A58E3CDB2A15639D48Be;\n', 'address Mercury = 0x00795263bdca13104309Db70c11E8404f81576BE;\n', 'address Europa = 0x00e4E3eac5b520BCa1030709a5f6f3dC8B9e1C37;\n', 'address Jupiter = 0x2C76F260707672e240DC639e5C9C62efAfB59867;\n', 'address Neptune = 0xEB04E1545a488A5018d2b5844F564135211d3696;\n', '\n', '/*CONTRACT ADDRESS*/\n', 'function GetContractAddr() public constant returns (address){\n', 'return this;\n', '}\t\n', 'address ContractAddr = GetContractAddr();\n', '\n', '\n', '/*AIRDROP RECEPIENTS*/\n', 'struct Accounting{\n', 'bool Received;    \n', '}\n', '\n', 'struct Admin{\n', 'bool Authorised; \n', 'uint256 Level;\n', '}\n', '\n', 'struct Config{\n', 'uint256 TocAmount;\t\n', 'address TocAddr;\n', '}\n', '\n', '/*DATA STORAGE*/\n', 'mapping (address => Accounting) public account;\n', 'mapping (address => Config) public config;\n', 'mapping (address => Admin) public admin;\n', '\n', '/*AUTHORISE ADMIN*/\n', 'function AuthAdmin(address _admin, bool _authority, uint256 _level) external \n', 'returns(bool) {\n', 'if((msg.sender != Mars) && (msg.sender != Mercury) && (msg.sender != Europa)\n', '&& (msg.sender != Jupiter) && (msg.sender != Neptune)) revert();  \n', 'admin[_admin].Authorised = _authority; \n', 'admin[_admin].Level = _level;\n', 'return true;\n', '} \n', '\n', '/*CONFIGURATION*/\n', 'function SetUp(uint256 _amount, address _tocaddr) external returns(bool){\n', '/*integrity checks*/      \n', 'if(admin[msg.sender].Authorised == false) revert();\n', 'if(admin[msg.sender].Level < 5 ) revert();\n', '/*update configuration records*/\n', 'config[ContractAddr].TocAmount = _amount;\n', 'config[ContractAddr].TocAddr = _tocaddr;\n', 'return true;\n', '}\n', '\n', '/*DEPOSIT TOC*/\n', 'function receiveApproval(address _from, uint256 _value, \n', 'address _token, bytes _extraData) external returns(bool){ \n', 'TOC\n', 'TOCCall = TOC(_token);\n', 'TOCCall.transferFrom(_from,this,_value);\n', 'return true;\n', '}\n', '\n', '/*WITHDRAW TOC*/\n', 'function Withdraw(uint256 _amount) external returns(bool){\n', '/*integrity checks*/      \n', 'if(admin[msg.sender].Authorised == false) revert();\n', 'if(admin[msg.sender].Level < 5 ) revert();\n', '/*withdraw TOC from this contract*/\n', 'TOC\n', 'TOCCall = TOC(config[ContractAddr].TocAddr);\n', 'TOCCall.transfer(msg.sender, _amount);\n', 'return true;\n', '}\n', '\n', '/*GET TOC*/\n', 'function Get() external returns(bool){\n', '/*integrity check-1*/      \n', 'if(account[msg.sender].Received == true) revert();\n', '/*change message sender received status*/\n', 'account[msg.sender].Received = true;\n', '/*send TOC to message sender*/\n', 'TOC\n', 'TOCCall = TOC(config[ContractAddr].TocAddr);\n', 'TOCCall.transfer(msg.sender, config[ContractAddr].TocAmount);\n', '/*integrity check-2*/      \n', 'assert(account[msg.sender].Received == true);\n', 'return true;\n', '}\n', '\n', '/*INVALID TRANSACTIONS*/\n', 'function () payable external{\n', 'revert();  \n', '}\n', '\n', '}////////////////////////////////end of AirdropDIST contract']
['pragma solidity ^0.4.16;\n', '\n', '/*SPEND APPROVAL ALERT INTERFACE*/\n', 'interface tokenRecipient { \n', 'function receiveApproval(address _from, uint256 _value, \n', 'address _token, bytes _extraData) external; \n', '}\n', '\n', 'contract TOC {\n', '/*tokenchanger.io*/\n', '\n', '/*TOC TOKEN*/\n', 'string public name;\n', 'string public symbol;\n', 'uint8 public decimals;\n', 'uint256 public totalSupply;\n', '\n', '/*user coin balance*/\n', 'mapping (address => uint256) public balances;\n', '/*user coin allowances*/\n', 'mapping(address => mapping (address => uint256)) public allowed;\n', '\n', '/*EVENTS*/\t\t\n', '/*broadcast token transfers on the blockchain*/\n', 'event Transfer(address indexed from, address indexed to, uint256 value);\n', '/*broadcast token spend approvals on the blockchain*/\n', 'event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\n', '/*MINT TOKEN*/\n', 'function TOC() public {\n', 'name = "Token Changer";\n', 'symbol = "TOC";\n', 'decimals = 18;\n', '/*one billion base units*/\n', 'totalSupply = 10**27;\n', 'balances[msg.sender] = totalSupply; \n', '}\n', '\n', '/*INTERNAL TRANSFER*/\n', 'function _transfer(address _from, address _to, uint _value) internal {    \n', '/*prevent transfer to invalid address*/    \n', 'if(_to == 0x0) revert();\n', '/*check if the sender has enough value to send*/\n', 'if(balances[_from] < _value) revert(); \n', '/*check for overflows*/\n', 'if(balances[_to] + _value < balances[_to]) revert();\n', '/*compute sending and receiving balances before transfer*/\n', 'uint PreviousBalances = balances[_from] + balances[_to];\n', '/*substract from sender*/\n', 'balances[_from] -= _value;\n', '/*add to the recipient*/\n', 'balances[_to] += _value; \n', '/*check integrity of transfer operation*/\n', 'assert(balances[_from] + balances[_to] == PreviousBalances);\n', '/*broadcast transaction*/\n', 'emit Transfer(_from, _to, _value); \n', '}\n', '\n', '/*PUBLIC TRANSFERS*/\n', 'function transfer(address _to, uint256 _value) external returns (bool){\n', '_transfer(msg.sender, _to, _value);\n', 'return true;\n', '}\n', '\n', '/*APPROVE THIRD PARTY SPENDING*/\n', 'function approve(address _spender, uint256 _value) public returns (bool success){\n', '/*update allowance record*/    \n', 'allowed[msg.sender][_spender] = _value;\n', '/*broadcast approval*/\n', 'emit Approval(msg.sender, _spender, _value); \n', 'return true;                                        \n', '}\n', '\n', '/*THIRD PARTY TRANSFER*/\n', 'function transferFrom(address _from, address _to, uint256 _value) \n', 'external returns (bool success) {\n', '/*check if the message sender can spend*/\n', 'require(_value <= allowed[_from][msg.sender]); \n', "/*substract from message sender's spend allowance*/\n", 'allowed[_from][msg.sender] -= _value;\n', '/*transfer tokens*/\n', '_transfer(_from, _to, _value);\n', 'return true;\n', '}\n', '\n', '/*APPROVE SPEND ALLOWANCE AND CALL SPENDER*/\n', 'function approveAndCall(address _spender, uint256 _value, \n', ' bytes _extraData) external returns (bool success) {\n', 'tokenRecipient \n', 'spender = tokenRecipient(_spender);\n', 'if(approve(_spender, _value)) {\n', 'spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '}\n', 'return true;\n', '}\n', '\n', '/*INVALID TRANSACTIONS*/\n', 'function () payable external{\n', 'revert();  \n', '}\n', '\n', '}/////////////////////////////////end of toc token contract\n', '\n', 'pragma solidity ^0.4.22;\n', '\n', 'contract AirdropDIST {\n', '/*(c)2018 tokenchanger.io -all rights reserved*/\n', '\n', '/*SUPER ADMINS*/\n', 'address Mars = 0x1947f347B6ECf1C3D7e1A58E3CDB2A15639D48Be;\n', 'address Mercury = 0x00795263bdca13104309Db70c11E8404f81576BE;\n', 'address Europa = 0x00e4E3eac5b520BCa1030709a5f6f3dC8B9e1C37;\n', 'address Jupiter = 0x2C76F260707672e240DC639e5C9C62efAfB59867;\n', 'address Neptune = 0xEB04E1545a488A5018d2b5844F564135211d3696;\n', '\n', '/*CONTRACT ADDRESS*/\n', 'function GetContractAddr() public constant returns (address){\n', 'return this;\n', '}\t\n', 'address ContractAddr = GetContractAddr();\n', '\n', '\n', '/*AIRDROP RECEPIENTS*/\n', 'struct Accounting{\n', 'bool Received;    \n', '}\n', '\n', 'struct Admin{\n', 'bool Authorised; \n', 'uint256 Level;\n', '}\n', '\n', 'struct Config{\n', 'uint256 TocAmount;\t\n', 'address TocAddr;\n', '}\n', '\n', '/*DATA STORAGE*/\n', 'mapping (address => Accounting) public account;\n', 'mapping (address => Config) public config;\n', 'mapping (address => Admin) public admin;\n', '\n', '/*AUTHORISE ADMIN*/\n', 'function AuthAdmin(address _admin, bool _authority, uint256 _level) external \n', 'returns(bool) {\n', 'if((msg.sender != Mars) && (msg.sender != Mercury) && (msg.sender != Europa)\n', '&& (msg.sender != Jupiter) && (msg.sender != Neptune)) revert();  \n', 'admin[_admin].Authorised = _authority; \n', 'admin[_admin].Level = _level;\n', 'return true;\n', '} \n', '\n', '/*CONFIGURATION*/\n', 'function SetUp(uint256 _amount, address _tocaddr) external returns(bool){\n', '/*integrity checks*/      \n', 'if(admin[msg.sender].Authorised == false) revert();\n', 'if(admin[msg.sender].Level < 5 ) revert();\n', '/*update configuration records*/\n', 'config[ContractAddr].TocAmount = _amount;\n', 'config[ContractAddr].TocAddr = _tocaddr;\n', 'return true;\n', '}\n', '\n', '/*DEPOSIT TOC*/\n', 'function receiveApproval(address _from, uint256 _value, \n', 'address _token, bytes _extraData) external returns(bool){ \n', 'TOC\n', 'TOCCall = TOC(_token);\n', 'TOCCall.transferFrom(_from,this,_value);\n', 'return true;\n', '}\n', '\n', '/*WITHDRAW TOC*/\n', 'function Withdraw(uint256 _amount) external returns(bool){\n', '/*integrity checks*/      \n', 'if(admin[msg.sender].Authorised == false) revert();\n', 'if(admin[msg.sender].Level < 5 ) revert();\n', '/*withdraw TOC from this contract*/\n', 'TOC\n', 'TOCCall = TOC(config[ContractAddr].TocAddr);\n', 'TOCCall.transfer(msg.sender, _amount);\n', 'return true;\n', '}\n', '\n', '/*GET TOC*/\n', 'function Get() external returns(bool){\n', '/*integrity check-1*/      \n', 'if(account[msg.sender].Received == true) revert();\n', '/*change message sender received status*/\n', 'account[msg.sender].Received = true;\n', '/*send TOC to message sender*/\n', 'TOC\n', 'TOCCall = TOC(config[ContractAddr].TocAddr);\n', 'TOCCall.transfer(msg.sender, config[ContractAddr].TocAmount);\n', '/*integrity check-2*/      \n', 'assert(account[msg.sender].Received == true);\n', 'return true;\n', '}\n', '\n', '/*INVALID TRANSACTIONS*/\n', 'function () payable external{\n', 'revert();  \n', '}\n', '\n', '}////////////////////////////////end of AirdropDIST contract']