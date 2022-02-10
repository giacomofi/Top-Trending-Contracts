['pragma solidity ^0.4.11;\n', '\n', '// ==== DISCLAIMER ====\n', '//\n', '// ETHEREUM IS STILL AN EXPEREMENTAL TECHNOLOGY.\n', '// ALTHOUGH THIS SMART CONTRACT WAS CREATED WITH GREAT CARE AND IN THE HOPE OF BEING USEFUL, NO GUARANTEES OF FLAWLESS OPERATION CAN BE GIVEN.\n', '// IN PARTICULAR - SUBTILE BUGS, HACKER ATTACKS OR MALFUNCTION OF UNDERLYING TECHNOLOGY CAN CAUSE UNINTENTIONAL BEHAVIOUR.\n', '// YOU ARE STRONGLY ENCOURAGED TO STUDY THIS SMART CONTRACT CAREFULLY IN ORDER TO UNDERSTAND POSSIBLE EDGE CASES AND RISKS.\n', "// DON'T USE THIS SMART CONTRACT IF YOU HAVE SUBSTANTIAL DOUBTS OR IF YOU DON'T KNOW WHAT YOU ARE DOING.\n", '//\n', '// THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY\n', '// AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,\n', '// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,\n', '// OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,\n', '// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\n', '// ====\n', '// all this file is based on code from open zepplin\n', '// https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token\n', '// Standard ERC20 token Clickle.de\n', '// @author Chainsulting.de - Blockchain Consulting \n', '// ==== DISCLAIMER ====\n', '\n', ' // @title SafeMath\n', ' // @dev Math operations with safety checks that throw on error\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', ' // @title ERC20Basic\n', ' // @dev Simpler version of ERC20 interface\n', ' // @dev see https://github.com/ethereum/EIPs/issues/179\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', ' \n', ' // @title ERC20 interface\n', ' // @dev see https://github.com/ethereum/EIPs/issues/20\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', ' \n', ' // @title Basic token\n', ' // @dev Basic version of StandardToken, with no allowances.\n', ' \n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  \n', '  // @dev transfer token for a specified address\n', '  // @param _to The address to transfer to.\n', '  // @param _value The amount to be transferred.\n', ' \n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  \n', '  // @dev Gets the balance of the specified address.\n', '  // @param _owner The address to query the the balance of.\n', '  // @return An uint256 representing the amount owned by the passed address.\n', ' \n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', ' // @title Standard ERC20 token\n', ' // @dev Implementation of the basic standard token.\n', ' // @dev https://github.com/ethereum/EIPs/issues/20\n', ' // @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  \n', '   // @dev Transfer tokens from one address to another\n', '   // @param _from address The address which you want to send tokens from\n', '   // @param _to address The address which you want to transfer to\n', '   // @param _value uint256 the amount of tokens to be transferred\n', '   \n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '   // @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   //\n', '   // Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   // and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   // race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   // @param _spender The address which will spend the funds.\n', '   // @param _value The amount of tokens to be spent.\n', '   \n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', ' \n', '   // @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   // @param _owner address The address which owns the funds.\n', '   // @param _spender address The address which will spend the funds.\n', '   // @return A uint256 specifying the amount of tokens still available for the spender.\n', '  \n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '\n', '   // approve should be called when allowed[_spender] == 0. To increment\n', '   // allowed value is better to use this function to avoid 2 calls (and wait until\n', '   // the first transaction is mined)\n', '   // From MonolithDAO Token.sol\n', '\n', '  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', ' // @title CLICKLE Token\n', ' // @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.\n', ' // Note they can later distribute these tokens as they wish using `transfer` and other\n', ' // StandardToken functions. 20.000.000 CLICK\n', '\n', 'contract CLICKLEToken is StandardToken {\n', '\n', '    string public name = "Clickle Token";\n', '    string public symbol = "CLICK";\n', '    uint public decimals = 8;\n', '    uint public INITIAL_SUPPLY = 2000000000000000; // Initial supply is 20,000,000 CLICK\n', '\n', '    function CLICKLEToken() {\n', '        totalSupply = INITIAL_SUPPLY;\n', '        balances[msg.sender] = INITIAL_SUPPLY; // Give the creator all initial tokens\n', '    }\n', '}']