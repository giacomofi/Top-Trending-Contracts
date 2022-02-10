['pragma solidity ^0.4.24;\n', '\n', 'contract PerformanceBond {\n', '/*(c)2018 tokenchanger.io -all rights reserved*/\n', '\n', '/*SUPER ADMINS*/\n', 'address Mars = 0x1947f347B6ECf1C3D7e1A58E3CDB2A15639D48Be;\n', 'address Mercury = 0x00795263bdca13104309Db70c11E8404f81576BE;\n', 'address Europa = 0x00e4E3eac5b520BCa1030709a5f6f3dC8B9e1C37;\n', 'address Jupiter = 0x2C76F260707672e240DC639e5C9C62efAfB59867;\n', 'address Neptune = 0xEB04E1545a488A5018d2b5844F564135211d3696;\n', '\n', '/*CONTRACT ADDRESS*/\n', 'function GetContractAddr() public constant returns (address){\n', 'return this;\n', '}\t\n', 'address ContractAddr = GetContractAddr();\n', '\n', '/*GLOBAL*/\n', 'uint256 PercentConverter = 10000;\n', '\n', '/*DATA STRUCTURE*/\n', 'struct Bond{\n', 'uint256 BondNum;\n', '}\n', '\n', 'struct Specification{\n', 'uint256 WriterDeposit;\n', 'uint256 BeneficiaryStake;\n', 'uint256 BeneficiaryDeposit;\n', 'uint256 ExtensionLimit;\n', 'uint256 CreationBlock;\n', 'uint256 ExpirationBlock;\n', 'address BondWriter;\n', 'address BondBeneficiary;\n', 'bool StopExtension;\n', 'bool Activated;\n', 'bool Dispute;\n', 'uint256 CtrFee;\n', 'uint256 ArbFee;\n', '}\n', '\n', 'struct Agreement{\n', 'address Arbiter;\n', 'bool Writer;    \n', 'bool Beneficiary;    \n', '}\n', '\n', 'struct Settlement{\n', 'uint256 Writer;    \n', 'uint256 Beneficiary;\n', 'bool WriterSettled;\n', 'bool BeneficiarySettled;\n', 'bool Judgement;\n', '}\n', '\n', 'struct User{\n', 'uint256 TransactionNum;\n', '}\n', '\n', 'struct Log{\n', 'uint256 BondNum;\n', '}\n', '\n', 'struct Admin{\n', 'bool Authorised; \n', 'uint256 Level;\n', '}\n', '\n', 'struct Arbiter{\n', 'bool Registered; \n', '}\n', '\n', 'struct Configuration{\n', 'uint256 ArbiterFee;\n', 'uint256 ContractFee;\n', 'uint256 StakePercent;\n', 'address Banker;\n', '}\n', '\n', 'struct TR{\n', 'uint256 n0;    \n', 'uint256 n1;\n', 'uint256 n2;\n', 'uint256 n3;\n', 'uint256 n4;\n', 'uint256 n5;\n', 'uint256 n6;\n', 'uint256 n7;\n', 'uint256 n8;\n', 'uint256 n9;\n', '}\n', '\n', 'struct Identifier {\n', 'uint256 c0;    \n', 'uint256 c1;\n', 'uint256 c2;\n', 'uint256 c3;\n', 'uint256 c4;\n', 'uint256 c5;\n', 'uint256 c6;\n', 'uint256 c7;\n', '}\n', '\n', '/*initialise process variables*/\n', 'TR tr;\n', 'Identifier id;\n', '\n', '/*DATA STORAGE*/\n', 'mapping (address => Bond) public bond;\n', 'mapping (uint256 => Specification) public spec;\n', 'mapping (uint256 => Agreement) public agree;\n', 'mapping (address => User) public user;\n', 'mapping (uint256 => Settlement) public settle;\n', 'mapping (address => mapping (uint256 => Log)) public tracker;\n', 'mapping (address => Configuration) public config;\n', 'mapping (address => Admin) public admin;\n', 'mapping (address => Arbiter) public arbiter;\n', '\n', '/*AUTHORISE ADMIN*/\n', 'function AuthAdmin(address _admin, bool _authority, uint256 _level) external \n', 'returns(bool) {\n', 'if((msg.sender != Mars) && (msg.sender != Mercury) && (msg.sender != Europa)\n', '&& (msg.sender != Jupiter) && (msg.sender != Neptune)) revert();  \n', 'admin[_admin].Authorised = _authority; \n', 'admin[_admin].Level = _level;\n', 'return true;\n', '} \n', '\n', '/*CONFIGURE CONTRACT*/\n', 'function SetUp(uint256 _afee,uint256 _cfee,uint256 _spercent,address _banker) \n', 'external returns(bool){\n', '/*integrity checks*/      \n', 'if(admin[msg.sender].Authorised == false) revert();\n', 'if(admin[msg.sender].Level < 5 ) revert();\n', '/*update contract configuration*/\n', 'config[ContractAddr].ArbiterFee = _afee;\n', 'config[ContractAddr].ContractFee = _cfee;\n', 'config[ContractAddr].StakePercent = _spercent;\n', 'config[ContractAddr].Banker = _banker;\n', 'return true;\n', '}\n', '\n', '/*REGISTER ARBITER*/\n', 'function Register(address arbiter_, bool authority_) external \n', 'returns(bool) {\n', '/*integrity checks*/      \n', 'if(admin[msg.sender].Authorised == false) revert();\n', 'if(admin[msg.sender].Level < 5 ) revert();\n', '/*register arbitrator*/\n', 'arbiter[arbiter_].Registered = authority_; \n', 'return true;\n', '}\n', '\n', '/*PERCENTAGE CALCULATOR*/\n', 'function Percent(uint256 _value, uint256 _percent) internal returns(uint256){\n', 'tr.n1 = mul(_value,_percent);\n', 'tr.n2 = div(tr.n1,PercentConverter);\n', 'return tr.n2;\n', '} \n', '\n', '/*WRITE PERFORMANCE BOND*/\n', 'function WriteBond(uint256 _expire, address _bene, address _arbi) payable external returns (bool){\n', '/*integrity checks*/    \n', 'if(msg.value <= 0) revert();\n', 'require(arbiter[_arbi].Registered == true);\n', '/*assign bond number*/\n', 'bond[ContractAddr].BondNum += 1;\n', 'tr.n3 = bond[ContractAddr].BondNum; \n', '/*write bond*/\n', 'spec[tr.n3].WriterDeposit = msg.value;\n', 'tr.n4 = Percent(msg.value,config[ContractAddr].StakePercent);\n', 'spec[tr.n3].BeneficiaryStake = tr.n4;\n', 'spec[tr.n3].ExtensionLimit = _expire;\n', 'spec[tr.n3].CreationBlock = block.number;\n', 'tr.n5 = add(block.number,_expire);\n', 'spec[tr.n3].ExpirationBlock = tr.n5;\n', 'spec[tr.n3].BondWriter = msg.sender;\n', 'spec[tr.n3].BondBeneficiary = _bene;\n', '/*create writer record*/\n', 'user[msg.sender].TransactionNum += 1;\n', 'tr.n6 = user[msg.sender].TransactionNum;\n', 'tracker[msg.sender][tr.n6].BondNum = tr.n3;\n', '/*create beneficiary record*/\n', 'user[_bene].TransactionNum += 1;\n', 'tr.n7 = user[_bene].TransactionNum;\n', 'tracker[_bene][tr.n7].BondNum = tr.n3;\n', '/*create arbitration record*/\n', 'agree[tr.n3].Arbiter = _arbi;\n', 'agree[tr.n3].Writer = true;\n', '/*determine transaction fees*/\n', 'tr.n0 = Percent(msg.value,config[ContractAddr].ContractFee);\n', 'id.c0 = Percent(msg.value,config[ContractAddr].ArbiterFee);\n', '/*transaction fees*/\n', 'spec[tr.n3].CtrFee = tr.n0;\n', 'spec[tr.n3].ArbFee = id.c0;\n', 'return true;\n', '}    \n', '\n', '/*STOP OR ENABLE CHANGE OF BOND EXPIRATION TIME*/\n', 'function ChangeExtension(uint256 _bondnum, bool _change) external returns(bool){\n', '/*integrity checks*/     \n', 'require(spec[_bondnum].BondWriter == msg.sender);\n', '/*change record*/\n', 'spec[_bondnum].StopExtension = _change;\n', 'return true;\n', '} \n', '\n', '/*DEPOSIT BENEFICIARY STAKE*/\n', 'function BeneficiaryStake(uint256 _bondnum) payable external returns(bool){\n', '/*integrity checks*/\n', 'if(msg.value <= 0) revert();\n', 'require(spec[_bondnum].BondBeneficiary == msg.sender);\n', 'require(spec[_bondnum].ExpirationBlock >= block.number);\n', 'require(spec[_bondnum].Activated == false);\n', 'require(settle[_bondnum].WriterSettled == false);\n', 'require(msg.value >= spec[_bondnum].BeneficiaryStake);\n', '/*change record*/\n', 'spec[_bondnum].Activated = true;\n', 'spec[_bondnum].BeneficiaryDeposit = msg.value;\n', 'return true;\n', '} \n', '\n', '/*APPOINT ARBITRATOR*/\n', 'function Appoint(uint256 _bondnum, address _arbi) external returns(bool){\n', '/*integrity checks*/\n', 'require(arbiter[_arbi].Registered == true); \n', 'if((agree[_bondnum].Writer ==true) && (agree[_bondnum].Beneficiary == true)) revert();\n', '/*bond beneficiary appointment*/     \n', 'if(spec[_bondnum].BondBeneficiary == msg.sender){\n', 'agree[_bondnum].Arbiter = _arbi;\n', 'agree[_bondnum].Beneficiary = true;\n', 'agree[_bondnum].Writer = false;\n', '}\n', '/*bond writer appointment*/     \n', 'if(spec[_bondnum].BondWriter == msg.sender){\n', 'agree[_bondnum].Arbiter = _arbi;\n', 'agree[_bondnum].Writer = true;\n', 'agree[_bondnum].Beneficiary = false;\n', '}\n', 'return true;\n', '} \n', '\n', '/*FILE A DISPUTE*/\n', 'function Dispute(uint256 _bondnum) external returns(bool){\n', '/*integrity checks*/     \n', 'require(spec[_bondnum].Activated == true);\n', 'require(settle[_bondnum].WriterSettled == false);    \n', 'require(settle[_bondnum].BeneficiarySettled == false);      \n', '/*bond beneficiary*/     \n', 'if(spec[_bondnum].BondBeneficiary == msg.sender){\n', 'spec[_bondnum].Dispute = true;\n', '}\n', '/*bond writer*/     \n', 'if(spec[_bondnum].BondWriter == msg.sender){\n', 'spec[_bondnum].Dispute = true;\n', '}\n', 'return true;\n', '} \n', '\n', '/*APPROVE ARBITRATOR*/\n', 'function Approve(uint256 _bondnum) external returns(bool){\n', '/*bond beneficiary approve*/     \n', 'if(spec[_bondnum].BondBeneficiary == msg.sender){\n', 'agree[_bondnum].Beneficiary = true;\n', '}\n', '/*bond writer approve*/     \n', 'if(spec[_bondnum].BondWriter == msg.sender){\n', 'agree[_bondnum].Writer = true;\n', '}\n', 'return true;\n', '} \n', '\n', '/*ARBITRATOR JUDGEMENT*/\n', 'function Judgement(uint256 _bondnum, uint256 writer_, uint256 bene_) external returns(bool){\n', '/*integrity check-1*/ \n', 'require(spec[_bondnum].Dispute == true);\n', 'require(agree[_bondnum].Arbiter == msg.sender);\n', 'require(agree[_bondnum].Writer == true);\n', 'require(agree[_bondnum].Beneficiary == true);\n', 'require(settle[_bondnum].Judgement == false);\n', '/*change judgement status*/\n', 'settle[_bondnum].Judgement = true;\n', '/*integrity check-2*/\n', 'tr.n8 = add(spec[_bondnum].WriterDeposit,spec[_bondnum].BeneficiaryDeposit);\n', 'tr.n9 = add(writer_,bene_);\n', 'assert(tr.n9 <= tr.n8);\n', '/*assign judgement values*/\n', 'settle[_bondnum].Writer = writer_;\n', 'settle[_bondnum].Beneficiary = bene_;\n', 'return true;\n', '} \n', '\n', '/*EXTEND PERFORMANCE BOND EXPIRATION TIME*/\n', 'function Extend(uint256 _bondnum, uint256 _blocks) external returns(bool){\n', '/*integrity checks*/  \n', 'require(spec[_bondnum].StopExtension == false);\n', 'require(spec[_bondnum].BondBeneficiary == msg.sender);\n', 'require(spec[_bondnum].ExpirationBlock >= block.number);\n', 'require(_blocks <= spec[_bondnum].ExtensionLimit);\n', '/*change record*/\n', 'spec[_bondnum].ExpirationBlock = add(block.number,_blocks);\n', 'return true;\n', '} \n', '\n', '/*SETTLE PERFORMANCE BOND*/\n', 'function SettleBond(uint256 _bondnum) external returns(bool){\n', '/*determine transaction fees*/     \n', 'id.c1 = spec[_bondnum].CtrFee;\n', 'id.c2 = spec[_bondnum].ArbFee;\n', 'id.c3 = add(id.c1,id.c2);\n', '\n', '/*non-activated bond: bond writer*/\n', 'if((spec[_bondnum].BondWriter == msg.sender) && (spec[_bondnum].Activated == false)){\n', '/*integrity checks*/ \n', 'require(settle[_bondnum].WriterSettled == false);\n', '/*change writer settlement status*/\n', 'settle[_bondnum].WriterSettled = true;\n', '/*settle performnace bond*/\n', 'msg.sender.transfer(spec[_bondnum].WriterDeposit);\n', 'assert(settle[_bondnum].WriterSettled == true);\n', '}\n', '\n', '/*activated bond is not disputed: bond writer*/\n', 'if((block.number > spec[_bondnum].ExpirationBlock) && (spec[_bondnum].Dispute == false)\n', '&& (spec[_bondnum].BondWriter == msg.sender) && (spec[_bondnum].Activated == true)){\n', '/*integrity checks*/ \n', 'require(settle[_bondnum].WriterSettled == false);\n', '/*change writer settlement status*/\n', 'settle[_bondnum].WriterSettled = true;\n', '/*settle performnace bond*/\n', 'id.c4 = sub(spec[_bondnum].WriterDeposit,id.c3);\n', 'config[ContractAddr].Banker.transfer(id.c1);\n', 'agree[_bondnum].Arbiter.transfer(id.c2);\n', 'msg.sender.transfer(id.c4);\n', 'assert(settle[_bondnum].WriterSettled == true);\n', '}/*bond writer: bond not disputed*/\n', '\n', '/*bond is disputed: bond writer*/\n', 'if((settle[_bondnum].Judgement == true) && (spec[_bondnum].Dispute == true)\n', '&& (spec[_bondnum].BondWriter == msg.sender)){\n', '/*integrity checks*/ \n', 'require(settle[_bondnum].WriterSettled == false);\n', '/*change writer settlement status*/\n', 'settle[_bondnum].WriterSettled = true;\n', '/*writer can pay fees*/\n', 'if(settle[_bondnum].Writer > id.c3){\n', 'id.c5 = sub(settle[_bondnum].Writer,id.c3);\n', 'config[ContractAddr].Banker.transfer(id.c1);\n', 'agree[_bondnum].Arbiter.transfer(id.c2);\n', 'msg.sender.transfer(id.c5);\n', '}/*writer can pay fees*/\n', 'assert(settle[_bondnum].WriterSettled == true);\n', '}\n', '\n', '/*bond is disputed: bond beneficiary*/\n', 'if((settle[_bondnum].Judgement == true) && (spec[_bondnum].Dispute == true)\n', '&& (spec[_bondnum].BondBeneficiary == msg.sender)){\n', '/*integrity checks*/ \n', 'require(settle[_bondnum].BeneficiarySettled == false);\n', '/*change beneficiary settlement status*/\n', 'settle[_bondnum].BeneficiarySettled = true;\n', '/*beneficiary can pay fees*/\n', 'if(settle[_bondnum].Beneficiary > id.c3){\n', 'id.c6 = sub(settle[_bondnum].Beneficiary,id.c3);\n', 'config[ContractAddr].Banker.transfer(id.c1);\n', 'agree[_bondnum].Arbiter.transfer(id.c2);\n', 'msg.sender.transfer(id.c6);\n', '}/*bond beneficiary can pay fees*/\n', 'assert(settle[_bondnum].BeneficiarySettled == true);\n', '}\n', '\n', '/*activated bond is not disputed: bond beneficiary*/\n', 'if((block.number > spec[_bondnum].ExpirationBlock) && (spec[_bondnum].Dispute == false)\n', '&& (spec[_bondnum].BondBeneficiary == msg.sender) && (spec[_bondnum].Activated == true)){\n', '/*integrity checks*/ \n', 'require(settle[_bondnum].BeneficiarySettled == false);\n', '/*change writer settlement status*/\n', 'settle[_bondnum].BeneficiarySettled = true;\n', '/*settle performnace bond*/\n', 'id.c7 = sub(spec[_bondnum].BeneficiaryDeposit,id.c3);\n', 'config[ContractAddr].Banker.transfer(id.c1);\n', 'agree[_bondnum].Arbiter.transfer(id.c2);\n', 'msg.sender.transfer(id.c7);\n', 'assert(settle[_bondnum].BeneficiarySettled == true);\n', '}/*bond beneficiary: no dispute*/\n', '\n', 'return true;\n', '}/*end of settle bond*/ \n', '\n', '/*INVALID TRANSACTIONS*/\n', 'function () payable external{\n', 'revert();  \n', '}\n', '\n', '/*SAFE MATHS*/\n', 'function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', 'function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '  \n', 'function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }  \n', ' function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '}////////////////////////////////end of PerformanceBond contract']
['pragma solidity ^0.4.24;\n', '\n', 'contract PerformanceBond {\n', '/*(c)2018 tokenchanger.io -all rights reserved*/\n', '\n', '/*SUPER ADMINS*/\n', 'address Mars = 0x1947f347B6ECf1C3D7e1A58E3CDB2A15639D48Be;\n', 'address Mercury = 0x00795263bdca13104309Db70c11E8404f81576BE;\n', 'address Europa = 0x00e4E3eac5b520BCa1030709a5f6f3dC8B9e1C37;\n', 'address Jupiter = 0x2C76F260707672e240DC639e5C9C62efAfB59867;\n', 'address Neptune = 0xEB04E1545a488A5018d2b5844F564135211d3696;\n', '\n', '/*CONTRACT ADDRESS*/\n', 'function GetContractAddr() public constant returns (address){\n', 'return this;\n', '}\t\n', 'address ContractAddr = GetContractAddr();\n', '\n', '/*GLOBAL*/\n', 'uint256 PercentConverter = 10000;\n', '\n', '/*DATA STRUCTURE*/\n', 'struct Bond{\n', 'uint256 BondNum;\n', '}\n', '\n', 'struct Specification{\n', 'uint256 WriterDeposit;\n', 'uint256 BeneficiaryStake;\n', 'uint256 BeneficiaryDeposit;\n', 'uint256 ExtensionLimit;\n', 'uint256 CreationBlock;\n', 'uint256 ExpirationBlock;\n', 'address BondWriter;\n', 'address BondBeneficiary;\n', 'bool StopExtension;\n', 'bool Activated;\n', 'bool Dispute;\n', 'uint256 CtrFee;\n', 'uint256 ArbFee;\n', '}\n', '\n', 'struct Agreement{\n', 'address Arbiter;\n', 'bool Writer;    \n', 'bool Beneficiary;    \n', '}\n', '\n', 'struct Settlement{\n', 'uint256 Writer;    \n', 'uint256 Beneficiary;\n', 'bool WriterSettled;\n', 'bool BeneficiarySettled;\n', 'bool Judgement;\n', '}\n', '\n', 'struct User{\n', 'uint256 TransactionNum;\n', '}\n', '\n', 'struct Log{\n', 'uint256 BondNum;\n', '}\n', '\n', 'struct Admin{\n', 'bool Authorised; \n', 'uint256 Level;\n', '}\n', '\n', 'struct Arbiter{\n', 'bool Registered; \n', '}\n', '\n', 'struct Configuration{\n', 'uint256 ArbiterFee;\n', 'uint256 ContractFee;\n', 'uint256 StakePercent;\n', 'address Banker;\n', '}\n', '\n', 'struct TR{\n', 'uint256 n0;    \n', 'uint256 n1;\n', 'uint256 n2;\n', 'uint256 n3;\n', 'uint256 n4;\n', 'uint256 n5;\n', 'uint256 n6;\n', 'uint256 n7;\n', 'uint256 n8;\n', 'uint256 n9;\n', '}\n', '\n', 'struct Identifier {\n', 'uint256 c0;    \n', 'uint256 c1;\n', 'uint256 c2;\n', 'uint256 c3;\n', 'uint256 c4;\n', 'uint256 c5;\n', 'uint256 c6;\n', 'uint256 c7;\n', '}\n', '\n', '/*initialise process variables*/\n', 'TR tr;\n', 'Identifier id;\n', '\n', '/*DATA STORAGE*/\n', 'mapping (address => Bond) public bond;\n', 'mapping (uint256 => Specification) public spec;\n', 'mapping (uint256 => Agreement) public agree;\n', 'mapping (address => User) public user;\n', 'mapping (uint256 => Settlement) public settle;\n', 'mapping (address => mapping (uint256 => Log)) public tracker;\n', 'mapping (address => Configuration) public config;\n', 'mapping (address => Admin) public admin;\n', 'mapping (address => Arbiter) public arbiter;\n', '\n', '/*AUTHORISE ADMIN*/\n', 'function AuthAdmin(address _admin, bool _authority, uint256 _level) external \n', 'returns(bool) {\n', 'if((msg.sender != Mars) && (msg.sender != Mercury) && (msg.sender != Europa)\n', '&& (msg.sender != Jupiter) && (msg.sender != Neptune)) revert();  \n', 'admin[_admin].Authorised = _authority; \n', 'admin[_admin].Level = _level;\n', 'return true;\n', '} \n', '\n', '/*CONFIGURE CONTRACT*/\n', 'function SetUp(uint256 _afee,uint256 _cfee,uint256 _spercent,address _banker) \n', 'external returns(bool){\n', '/*integrity checks*/      \n', 'if(admin[msg.sender].Authorised == false) revert();\n', 'if(admin[msg.sender].Level < 5 ) revert();\n', '/*update contract configuration*/\n', 'config[ContractAddr].ArbiterFee = _afee;\n', 'config[ContractAddr].ContractFee = _cfee;\n', 'config[ContractAddr].StakePercent = _spercent;\n', 'config[ContractAddr].Banker = _banker;\n', 'return true;\n', '}\n', '\n', '/*REGISTER ARBITER*/\n', 'function Register(address arbiter_, bool authority_) external \n', 'returns(bool) {\n', '/*integrity checks*/      \n', 'if(admin[msg.sender].Authorised == false) revert();\n', 'if(admin[msg.sender].Level < 5 ) revert();\n', '/*register arbitrator*/\n', 'arbiter[arbiter_].Registered = authority_; \n', 'return true;\n', '}\n', '\n', '/*PERCENTAGE CALCULATOR*/\n', 'function Percent(uint256 _value, uint256 _percent) internal returns(uint256){\n', 'tr.n1 = mul(_value,_percent);\n', 'tr.n2 = div(tr.n1,PercentConverter);\n', 'return tr.n2;\n', '} \n', '\n', '/*WRITE PERFORMANCE BOND*/\n', 'function WriteBond(uint256 _expire, address _bene, address _arbi) payable external returns (bool){\n', '/*integrity checks*/    \n', 'if(msg.value <= 0) revert();\n', 'require(arbiter[_arbi].Registered == true);\n', '/*assign bond number*/\n', 'bond[ContractAddr].BondNum += 1;\n', 'tr.n3 = bond[ContractAddr].BondNum; \n', '/*write bond*/\n', 'spec[tr.n3].WriterDeposit = msg.value;\n', 'tr.n4 = Percent(msg.value,config[ContractAddr].StakePercent);\n', 'spec[tr.n3].BeneficiaryStake = tr.n4;\n', 'spec[tr.n3].ExtensionLimit = _expire;\n', 'spec[tr.n3].CreationBlock = block.number;\n', 'tr.n5 = add(block.number,_expire);\n', 'spec[tr.n3].ExpirationBlock = tr.n5;\n', 'spec[tr.n3].BondWriter = msg.sender;\n', 'spec[tr.n3].BondBeneficiary = _bene;\n', '/*create writer record*/\n', 'user[msg.sender].TransactionNum += 1;\n', 'tr.n6 = user[msg.sender].TransactionNum;\n', 'tracker[msg.sender][tr.n6].BondNum = tr.n3;\n', '/*create beneficiary record*/\n', 'user[_bene].TransactionNum += 1;\n', 'tr.n7 = user[_bene].TransactionNum;\n', 'tracker[_bene][tr.n7].BondNum = tr.n3;\n', '/*create arbitration record*/\n', 'agree[tr.n3].Arbiter = _arbi;\n', 'agree[tr.n3].Writer = true;\n', '/*determine transaction fees*/\n', 'tr.n0 = Percent(msg.value,config[ContractAddr].ContractFee);\n', 'id.c0 = Percent(msg.value,config[ContractAddr].ArbiterFee);\n', '/*transaction fees*/\n', 'spec[tr.n3].CtrFee = tr.n0;\n', 'spec[tr.n3].ArbFee = id.c0;\n', 'return true;\n', '}    \n', '\n', '/*STOP OR ENABLE CHANGE OF BOND EXPIRATION TIME*/\n', 'function ChangeExtension(uint256 _bondnum, bool _change) external returns(bool){\n', '/*integrity checks*/     \n', 'require(spec[_bondnum].BondWriter == msg.sender);\n', '/*change record*/\n', 'spec[_bondnum].StopExtension = _change;\n', 'return true;\n', '} \n', '\n', '/*DEPOSIT BENEFICIARY STAKE*/\n', 'function BeneficiaryStake(uint256 _bondnum) payable external returns(bool){\n', '/*integrity checks*/\n', 'if(msg.value <= 0) revert();\n', 'require(spec[_bondnum].BondBeneficiary == msg.sender);\n', 'require(spec[_bondnum].ExpirationBlock >= block.number);\n', 'require(spec[_bondnum].Activated == false);\n', 'require(settle[_bondnum].WriterSettled == false);\n', 'require(msg.value >= spec[_bondnum].BeneficiaryStake);\n', '/*change record*/\n', 'spec[_bondnum].Activated = true;\n', 'spec[_bondnum].BeneficiaryDeposit = msg.value;\n', 'return true;\n', '} \n', '\n', '/*APPOINT ARBITRATOR*/\n', 'function Appoint(uint256 _bondnum, address _arbi) external returns(bool){\n', '/*integrity checks*/\n', 'require(arbiter[_arbi].Registered == true); \n', 'if((agree[_bondnum].Writer ==true) && (agree[_bondnum].Beneficiary == true)) revert();\n', '/*bond beneficiary appointment*/     \n', 'if(spec[_bondnum].BondBeneficiary == msg.sender){\n', 'agree[_bondnum].Arbiter = _arbi;\n', 'agree[_bondnum].Beneficiary = true;\n', 'agree[_bondnum].Writer = false;\n', '}\n', '/*bond writer appointment*/     \n', 'if(spec[_bondnum].BondWriter == msg.sender){\n', 'agree[_bondnum].Arbiter = _arbi;\n', 'agree[_bondnum].Writer = true;\n', 'agree[_bondnum].Beneficiary = false;\n', '}\n', 'return true;\n', '} \n', '\n', '/*FILE A DISPUTE*/\n', 'function Dispute(uint256 _bondnum) external returns(bool){\n', '/*integrity checks*/     \n', 'require(spec[_bondnum].Activated == true);\n', 'require(settle[_bondnum].WriterSettled == false);    \n', 'require(settle[_bondnum].BeneficiarySettled == false);      \n', '/*bond beneficiary*/     \n', 'if(spec[_bondnum].BondBeneficiary == msg.sender){\n', 'spec[_bondnum].Dispute = true;\n', '}\n', '/*bond writer*/     \n', 'if(spec[_bondnum].BondWriter == msg.sender){\n', 'spec[_bondnum].Dispute = true;\n', '}\n', 'return true;\n', '} \n', '\n', '/*APPROVE ARBITRATOR*/\n', 'function Approve(uint256 _bondnum) external returns(bool){\n', '/*bond beneficiary approve*/     \n', 'if(spec[_bondnum].BondBeneficiary == msg.sender){\n', 'agree[_bondnum].Beneficiary = true;\n', '}\n', '/*bond writer approve*/     \n', 'if(spec[_bondnum].BondWriter == msg.sender){\n', 'agree[_bondnum].Writer = true;\n', '}\n', 'return true;\n', '} \n', '\n', '/*ARBITRATOR JUDGEMENT*/\n', 'function Judgement(uint256 _bondnum, uint256 writer_, uint256 bene_) external returns(bool){\n', '/*integrity check-1*/ \n', 'require(spec[_bondnum].Dispute == true);\n', 'require(agree[_bondnum].Arbiter == msg.sender);\n', 'require(agree[_bondnum].Writer == true);\n', 'require(agree[_bondnum].Beneficiary == true);\n', 'require(settle[_bondnum].Judgement == false);\n', '/*change judgement status*/\n', 'settle[_bondnum].Judgement = true;\n', '/*integrity check-2*/\n', 'tr.n8 = add(spec[_bondnum].WriterDeposit,spec[_bondnum].BeneficiaryDeposit);\n', 'tr.n9 = add(writer_,bene_);\n', 'assert(tr.n9 <= tr.n8);\n', '/*assign judgement values*/\n', 'settle[_bondnum].Writer = writer_;\n', 'settle[_bondnum].Beneficiary = bene_;\n', 'return true;\n', '} \n', '\n', '/*EXTEND PERFORMANCE BOND EXPIRATION TIME*/\n', 'function Extend(uint256 _bondnum, uint256 _blocks) external returns(bool){\n', '/*integrity checks*/  \n', 'require(spec[_bondnum].StopExtension == false);\n', 'require(spec[_bondnum].BondBeneficiary == msg.sender);\n', 'require(spec[_bondnum].ExpirationBlock >= block.number);\n', 'require(_blocks <= spec[_bondnum].ExtensionLimit);\n', '/*change record*/\n', 'spec[_bondnum].ExpirationBlock = add(block.number,_blocks);\n', 'return true;\n', '} \n', '\n', '/*SETTLE PERFORMANCE BOND*/\n', 'function SettleBond(uint256 _bondnum) external returns(bool){\n', '/*determine transaction fees*/     \n', 'id.c1 = spec[_bondnum].CtrFee;\n', 'id.c2 = spec[_bondnum].ArbFee;\n', 'id.c3 = add(id.c1,id.c2);\n', '\n', '/*non-activated bond: bond writer*/\n', 'if((spec[_bondnum].BondWriter == msg.sender) && (spec[_bondnum].Activated == false)){\n', '/*integrity checks*/ \n', 'require(settle[_bondnum].WriterSettled == false);\n', '/*change writer settlement status*/\n', 'settle[_bondnum].WriterSettled = true;\n', '/*settle performnace bond*/\n', 'msg.sender.transfer(spec[_bondnum].WriterDeposit);\n', 'assert(settle[_bondnum].WriterSettled == true);\n', '}\n', '\n', '/*activated bond is not disputed: bond writer*/\n', 'if((block.number > spec[_bondnum].ExpirationBlock) && (spec[_bondnum].Dispute == false)\n', '&& (spec[_bondnum].BondWriter == msg.sender) && (spec[_bondnum].Activated == true)){\n', '/*integrity checks*/ \n', 'require(settle[_bondnum].WriterSettled == false);\n', '/*change writer settlement status*/\n', 'settle[_bondnum].WriterSettled = true;\n', '/*settle performnace bond*/\n', 'id.c4 = sub(spec[_bondnum].WriterDeposit,id.c3);\n', 'config[ContractAddr].Banker.transfer(id.c1);\n', 'agree[_bondnum].Arbiter.transfer(id.c2);\n', 'msg.sender.transfer(id.c4);\n', 'assert(settle[_bondnum].WriterSettled == true);\n', '}/*bond writer: bond not disputed*/\n', '\n', '/*bond is disputed: bond writer*/\n', 'if((settle[_bondnum].Judgement == true) && (spec[_bondnum].Dispute == true)\n', '&& (spec[_bondnum].BondWriter == msg.sender)){\n', '/*integrity checks*/ \n', 'require(settle[_bondnum].WriterSettled == false);\n', '/*change writer settlement status*/\n', 'settle[_bondnum].WriterSettled = true;\n', '/*writer can pay fees*/\n', 'if(settle[_bondnum].Writer > id.c3){\n', 'id.c5 = sub(settle[_bondnum].Writer,id.c3);\n', 'config[ContractAddr].Banker.transfer(id.c1);\n', 'agree[_bondnum].Arbiter.transfer(id.c2);\n', 'msg.sender.transfer(id.c5);\n', '}/*writer can pay fees*/\n', 'assert(settle[_bondnum].WriterSettled == true);\n', '}\n', '\n', '/*bond is disputed: bond beneficiary*/\n', 'if((settle[_bondnum].Judgement == true) && (spec[_bondnum].Dispute == true)\n', '&& (spec[_bondnum].BondBeneficiary == msg.sender)){\n', '/*integrity checks*/ \n', 'require(settle[_bondnum].BeneficiarySettled == false);\n', '/*change beneficiary settlement status*/\n', 'settle[_bondnum].BeneficiarySettled = true;\n', '/*beneficiary can pay fees*/\n', 'if(settle[_bondnum].Beneficiary > id.c3){\n', 'id.c6 = sub(settle[_bondnum].Beneficiary,id.c3);\n', 'config[ContractAddr].Banker.transfer(id.c1);\n', 'agree[_bondnum].Arbiter.transfer(id.c2);\n', 'msg.sender.transfer(id.c6);\n', '}/*bond beneficiary can pay fees*/\n', 'assert(settle[_bondnum].BeneficiarySettled == true);\n', '}\n', '\n', '/*activated bond is not disputed: bond beneficiary*/\n', 'if((block.number > spec[_bondnum].ExpirationBlock) && (spec[_bondnum].Dispute == false)\n', '&& (spec[_bondnum].BondBeneficiary == msg.sender) && (spec[_bondnum].Activated == true)){\n', '/*integrity checks*/ \n', 'require(settle[_bondnum].BeneficiarySettled == false);\n', '/*change writer settlement status*/\n', 'settle[_bondnum].BeneficiarySettled = true;\n', '/*settle performnace bond*/\n', 'id.c7 = sub(spec[_bondnum].BeneficiaryDeposit,id.c3);\n', 'config[ContractAddr].Banker.transfer(id.c1);\n', 'agree[_bondnum].Arbiter.transfer(id.c2);\n', 'msg.sender.transfer(id.c7);\n', 'assert(settle[_bondnum].BeneficiarySettled == true);\n', '}/*bond beneficiary: no dispute*/\n', '\n', 'return true;\n', '}/*end of settle bond*/ \n', '\n', '/*INVALID TRANSACTIONS*/\n', 'function () payable external{\n', 'revert();  \n', '}\n', '\n', '/*SAFE MATHS*/\n', 'function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', 'function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '  \n', 'function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }  \n', ' function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '}////////////////////////////////end of PerformanceBond contract']