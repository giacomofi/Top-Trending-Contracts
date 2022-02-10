['pragma solidity ^0.4.20;\n', 'contract tokenRecipient\n', '  {\n', '  function receiveApproval(address from, uint256 value, address token, bytes extraData) public; \n', '  }\n', 'contract ECP_Token // ECP Smart Contract Start\n', '  {\n', '     /* Variables For Contract */\n', '    string  public name;                                                        // Variable To Store Name\n', '    string  public symbol;                                                      // Variable To Store Symbol\n', '    uint8   public decimals;                                                    // Variable To Store Decimals\n', '    uint256 public totalSupply;                                                 // Variable To Store Total Supply Of Tokens\n', '    uint256 public remaining;                                                   // Variable To Store Smart Remaining Tokens\n', '    address public owner;                                                       // Variable To Store Smart Contract Owner\n', '    uint    public icoStatus;                                                   // Variable To Store Smart Contract Status ( Enable / Disabled )\n', '    address public benAddress;                                                  // Variable To Store Ben Address\n', '    address public bkaddress;                                                   // Variable To Store Backup Ben Address\n', '    uint    public allowTransferToken;                                          // Variable To Store If Transfer Is Enable Or Disabled\n', '\n', '     /* Array For Contract*/\n', '    mapping (address => uint256) public balanceOf;                              // Arrary To Store Ether Addresses\n', '    mapping (address => mapping (address => uint256)) public allowance;         // Arrary To Store Ether Addresses For Allowance\n', '    mapping (address => bool) public frozenAccount;                             // Arrary To Store Ether Addresses For Frozen Account\n', '\n', '    /* Events For Contract  */\n', '    event FrozenFunds(address target, bool frozen);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '    event TokenTransferEvent(address indexed from, address indexed to, uint256 value, string typex);\n', '\n', '\n', '     /* Initialize Smart Contract */\n', '    function ECP_Token() public\n', '    {\n', '      totalSupply = 15000000000000000000000000000;                              // Total Supply 15 Billion Tokens\n', '      owner =  msg.sender;                                                      // Smart Contract Owner\n', '      balanceOf[owner] = totalSupply;                                           // Credit Tokens To Owner\n', '      name = "ECP Token";                                                       // Set Name Of Token\n', '      symbol = "ECP";                                                           // Set Symbol Of Token\n', '      decimals = 18;                                                            // Set Decimals\n', '      remaining = totalSupply;                                                  // Set How Many Tokens Left\n', '      icoStatus = 1;                                                            // Set ICO Status As Active At Beginning\n', '      benAddress = 0xe4a7a715bE044186a3ac5C60c7Df7dD1215f7419;\n', '      bkaddress  = 0x44e00602e4B8F546f76983de2489d636CB443722;\n', '      allowTransferToken = 1;                                                   // Default Set Allow Transfer To Active\n', '    }\n', '\n', '   modifier onlyOwner()                                                         // Create Modifier\n', '    {\n', '        require((msg.sender == owner) || (msg.sender ==  bkaddress));\n', '        _;\n', '    }\n', '\n', '\n', '    function () public payable                                                  // Default Function\n', '    {\n', '    }\n', '\n', '    function sendToMultipleAccount (address[] dests, uint256[] values) public onlyOwner returns (uint256) // Function To Send Token To Multiple Account At A Time\n', '    {\n', '        uint256 i = 0;\n', '        while (i < dests.length) {\n', '\n', '                if(remaining > 0)\n', '                {\n', '                     _transfer(owner, dests[i], values[i]);  // Transfer Token Via Internal Transfer Function\n', "                     TokenTransferEvent(owner, dests[i], values[i],'MultipleAccount'); // Raise Event After Transfer\n", '                }\n', '                else\n', '                {\n', '                    revert();\n', '                }\n', '\n', '            i += 1;\n', '        }\n', '        return(i);\n', '    }\n', '\n', '\n', '    function sendTokenToSingleAccount(address receiversAddress ,uint256 amountToTransfer) public onlyOwner  // Function To Send Token To Single Account At A Time\n', '    {\n', '        if (remaining > 0)\n', '        {\n', '                     _transfer(owner, receiversAddress, amountToTransfer);  // Transfer Token Via Internal Transfer Function\n', "                     TokenTransferEvent(owner, receiversAddress, amountToTransfer,'SingleAccount'); // Raise Event After Transfer\n", '        }\n', '        else\n', '        {\n', '            revert();\n', '        }\n', '    }\n', '\n', '\n', '    function setTransferStatus (uint st) public  onlyOwner                      // Set Transfer Status\n', '    {\n', '        allowTransferToken = st;\n', '    }\n', '\n', '    function changeIcoStatus (uint8 st)  public onlyOwner                       // Change ICO Status\n', '    {\n', '        icoStatus = st;\n', '    }\n', '\n', '\n', '    function withdraw(uint amountWith) public onlyOwner                         // Withdraw Funds From Contract\n', '        {\n', '            if((msg.sender == owner) || (msg.sender ==  bkaddress))\n', '            {\n', '                benAddress.transfer(amountWith);\n', '            }\n', '            else\n', '            {\n', '                revert();\n', '            }\n', '        }\n', '\n', '    function withdraw_all() public onlyOwner                                    // Withdraw All Funds From Contract\n', '        {\n', '            if((msg.sender == owner) || (msg.sender ==  bkaddress) )\n', '            {\n', '                var amountWith = this.balance - 10000000000000000;\n', '                benAddress.transfer(amountWith);\n', '            }\n', '            else\n', '            {\n', '                revert();\n', '            }\n', '        }\n', '\n', '    function mintToken(uint256 tokensToMint) public onlyOwner                   // Mint Tokens\n', '        {\n', '            if(tokensToMint > 0)\n', '            {\n', '                var totalTokenToMint = tokensToMint * (10 ** 18);               // Calculate Tokens To Mint\n', '                balanceOf[owner] += totalTokenToMint;                           // Credit To Owners Account\n', '                totalSupply += totalTokenToMint;                                // Update Total Supply\n', '                remaining += totalTokenToMint;                                  // Update Remaining\n', '                Transfer(0, owner, totalTokenToMint);                           // Raise The Event\n', '            }\n', '        }\n', '\n', '\n', '\t function adm_trasfer(address _from,address _to, uint256 _value)  public onlyOwner // Admin Transfer Tokens\n', '\t\t  {\n', '\t\t\t  _transfer(_from, _to, _value);\n', '\t\t  }\n', '\n', '\n', '    function freezeAccount(address target, bool freeze) public onlyOwner        // Freeze Account\n', '        {\n', '            frozenAccount[target] = freeze;\n', '            FrozenFunds(target, freeze);\n', '        }\n', '\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) // ERC20 Function Implementation To Show Account Balance\n', '        {\n', '            return balanceOf[_owner];\n', '        }\n', '\n', '    function totalSupply() private constant returns (uint256 tsupply)           // ERC20 Function Implementation To Show Total Supply\n', '        {\n', '            tsupply = totalSupply;\n', '        }\n', '\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner               // Function Implementation To Transfer Ownership\n', '        {\n', '            balanceOf[owner] = 0;\n', '            balanceOf[newOwner] = remaining;\n', '            owner = newOwner;\n', '        }\n', '\n', '  function _transfer(address _from, address _to, uint _value) internal          // Internal Function To Transfer Tokens\n', '      {\n', '          if(allowTransferToken == 1 || _from == owner )\n', '          {\n', '              require(!frozenAccount[_from]);                                   // Prevent Transfer From Frozenfunds\n', '              require (_to != 0x0);                                             // Prevent Transfer To 0x0 Address.\n', '              require (balanceOf[_from] > _value);                              // Check If The Sender Has Enough Tokens To Transfer\n', '              require (balanceOf[_to] + _value > balanceOf[_to]);               // Check For Overflows\n', '              balanceOf[_from] -= _value;                                       // Subtract From The Sender\n', '              balanceOf[_to] += _value;                                         // Add To The Recipient\n', '              Transfer(_from, _to, _value);                                     // Raise Event After Transfer\n', '          }\n', '          else\n', '          {\n', '               revert();\n', '          }\n', '      }\n', '\n', '  function transfer(address _to, uint256 _value)  public                        // ERC20 Function Implementation To Transfer Tokens\n', '      {\n', '          _transfer(msg.sender, _to, _value);\n', '      }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) // ERC20 Function Implementation Of Transfer From\n', '      {\n', '          require (_value < allowance[_from][msg.sender]);                      // Check Has Permission To Transfer\n', '          allowance[_from][msg.sender] -= _value;                               // Minus From Available\n', '          _transfer(_from, _to, _value);                                        // Credit To Receiver\n', '          return true;\n', '      }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool success) // ERC20 Function Implementation Of Approve\n', '      {\n', '          allowance[msg.sender][_spender] = _value;\n', '          return true;\n', '      }\n', '\n', '  function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) // ERC20 Function Implementation Of Approve & Call\n', '      {\n', '          tokenRecipient spender = tokenRecipient(_spender);\n', '          if (approve(_spender, _value)) {\n', '              spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '              return true;\n', '          }\n', '      }\n', '\n', '  function burn(uint256 _value) public returns (bool success)                   // ERC20 Function Implementation Of Burn\n', '      {\n', '          require (balanceOf[msg.sender] > _value);                             // Check If The Sender Has Enough Balance\n', '          balanceOf[msg.sender] -= _value;                                      // Subtract From The Sender\n', '          totalSupply -= _value;                                                // Updates TotalSupply\n', '          remaining -= _value;                                                  // Update Remaining Tokens\n', '          Burn(msg.sender, _value);                                             // Raise Event\n', '          return true;\n', '      }\n', '\n', '  function burnFrom(address _from, uint256 _value) public returns (bool success) // ERC20 Function Implementation Of Burn From\n', '      {\n', '          require(balanceOf[_from] >= _value);                                  // Check If The Target Has Enough Balance\n', '          require(_value <= allowance[_from][msg.sender]);                      // Check Allowance\n', '          balanceOf[_from] -= _value;                                           // Subtract From The Targeted Balance\n', "          allowance[_from][msg.sender] -= _value;                               // Subtract From The Sender's Allowance\n", '          totalSupply -= _value;                                                // Update TotalSupply\n', '          remaining -= _value;                                                  // Update Remaining\n', '          Burn(_from, _value);\n', '          return true;\n', '      }\n', '} //  ECP Smart Contract End']