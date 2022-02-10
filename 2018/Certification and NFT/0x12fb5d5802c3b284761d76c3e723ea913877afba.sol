['pragma solidity ^0.4.15;\n', '\n', '/*\n', 'Copyright (c) 2016 Smart Contract Solutions, Inc.\n', '\n', 'Permission is hereby granted, free of charge, to any person obtaining\n', 'a copy of this software and associated documentation files (the\n', '"Software"), to deal in the Software without restriction, including\n', 'without limitation the rights to use, copy, modify, merge, publish,\n', 'distribute, sublicense, and/or sell copies of the Software, and to\n', 'permit persons to whom the Software is furnished to do so, subject to\n', 'the following conditions:\n', '\n', 'The above copyright notice and this permission notice shall be included\n', 'in all copies or substantial portions of the Software.\n', '\n', 'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS\n', 'OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF\n', 'MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.\n', 'IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY\n', 'CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,\n', 'TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE\n', 'SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n', '*/\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract basicToken {\n', '    function balanceOf(address) public view returns (uint256);\n', '    function transfer(address, uint256) public returns (bool);\n', '    function transferFrom(address, address, uint256) public returns (bool);\n', '    function approve(address, uint256) public returns (bool);\n', '    function allowance(address, address) public view returns (uint256);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract ERC20Standard is basicToken{\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    mapping (address => uint256) public balances;\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) public returns (bool success){\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address\n', '        require (balances[msg.sender] > _value);            // Check if the sender has enough\n', '        require (balances[_to] + _value > balances[_to]);   // Check for overflows\n', '        _transfer(msg.sender, _to, _value);                 // Perform actually transfer\n', '        Transfer(msg.sender, _to, _value);                  // Trigger Transfer event\n', '        return true;\n', '    }\n', '\n', '    /* Use admin powers to send from a users account */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address\n', '        require (balances[msg.sender] > _value);            // Check if the sender has enough\n', '        require (balances[_to] + _value > balances[_to]);   // Check for overflows\n', '        require (allowed[_from][msg.sender] >= _value);     // Only allow if sender is allowed to do this\n', '        _transfer(msg.sender, _to, _value);                 // Perform actually transfer\n', '        Transfer(msg.sender, _to, _value);                  // Trigger Transfer event\n', '        return true;\n', '    }\n', '\n', '    /* Internal transfer, only can be called by this contract */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        balances[_from] -= _value;                          // Subtract from the sender\n', '        balances[_to] += _value;                            // Add the same to the recipient\n', '    }\n', '\n', '    /* Get balance of an account */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /* Approve an address to have admin power to use transferFrom */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', 'contract HydroToken is ERC20Standard, owned{\n', '    event Authenticate(uint partnerId, address indexed from, uint value);     // Event for when an address is authenticated\n', '    event Whitelist(uint partnerId, address target, bool whitelist);          // Event for when an address is whitelisted to authenticate\n', '    event Burn(address indexed burner, uint256 value);                        // Event for when tokens are burned\n', '\n', '    struct partnerValues {\n', '        uint value;\n', '        uint challenge;\n', '    }\n', '\n', '    struct hydrogenValues {\n', '        uint value;\n', '        uint timestamp;\n', '    }\n', '\n', '    string public name = "Hydro";\n', '    string public symbol = "HYDRO";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply;\n', '\n', '    /* This creates an array of all whitelisted addresses\n', '     * Must be whitelisted to be able to utilize auth\n', '     */\n', '    mapping (uint => mapping (address => bool)) public whitelist;\n', '    mapping (uint => mapping (address => partnerValues)) public partnerMap;\n', '    mapping (uint => mapping (address => hydrogenValues)) public hydroPartnerMap;\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function HydroToken() public {\n', '        totalSupply = 11111111111 * 10**18;\n', '        balances[msg.sender] = totalSupply;                 // Give the creator all initial tokens\n', '    }\n', '\n', '    /* Function to whitelist partner address. Can only be called by owner */\n', '    function whitelistAddress(address _target, bool _whitelistBool, uint _partnerId) public onlyOwner {\n', '        whitelist[_partnerId][_target] = _whitelistBool;\n', '        Whitelist(_partnerId, _target, _whitelistBool);\n', '    }\n', '\n', '    /* Function to authenticate user\n', '       Restricted to whitelisted partners */\n', '    function authenticate(uint _value, uint _challenge, uint _partnerId) public {\n', '        require(whitelist[_partnerId][msg.sender]);         // Make sure the sender is whitelisted\n', '        require(balances[msg.sender] > _value);             // Check if the sender has enough\n', '        require(hydroPartnerMap[_partnerId][msg.sender].value == _value);\n', '        updatePartnerMap(msg.sender, _value, _challenge, _partnerId);\n', '        transfer(owner, _value);\n', '        Authenticate(_partnerId, msg.sender, _value);\n', '    }\n', '\n', '    function burn(uint256 _value) public onlyOwner {\n', '        require(balances[msg.sender] > _value);\n', '        balances[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        Burn(msg.sender, _value);\n', '    }\n', '\n', '    function checkForValidChallenge(address _sender, uint _partnerId) public view returns (uint value){\n', '        if (hydroPartnerMap[_partnerId][_sender].timestamp > block.timestamp){\n', '            return hydroPartnerMap[_partnerId][_sender].value;\n', '        }\n', '        return 1;\n', '    }\n', '\n', '    /* Function to update the partnerValuesMap with their amount and challenge string */\n', '    function updatePartnerMap(address _sender, uint _value, uint _challenge, uint _partnerId) internal {\n', '        partnerMap[_partnerId][_sender].value = _value;\n', '        partnerMap[_partnerId][_sender].challenge = _challenge;\n', '    }\n', '\n', '    /* Function to update the hydrogenValuesMap. Called exclusively from the Hydro API */\n', '    function updateHydroMap(address _sender, uint _value, uint _partnerId) public onlyOwner {\n', '        hydroPartnerMap[_partnerId][_sender].value = _value;\n', '        hydroPartnerMap[_partnerId][_sender].timestamp = block.timestamp + 1 days;\n', '    }\n', '\n', '    /* Function called by Hydro API to check if the partner has validated\n', '     * The partners value and data must match and it must be less than a day since the last authentication\n', '     */\n', '    function validateAuthentication(address _sender, uint _challenge, uint _partnerId) public constant returns (bool _isValid) {\n', '        if (partnerMap[_partnerId][_sender].value == hydroPartnerMap[_partnerId][_sender].value\n', '        && block.timestamp < hydroPartnerMap[_partnerId][_sender].timestamp\n', '        && partnerMap[_partnerId][_sender].challenge == _challenge){\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '}']