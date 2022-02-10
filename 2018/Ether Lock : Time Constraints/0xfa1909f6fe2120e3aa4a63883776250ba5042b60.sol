['pragma solidity 0.4.23;\n', '\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '/// @title Escrow contract\n', '/// @author Farah\n', "/// @notice It's a contract for escrow based creating, claiming and rewarding jobs.\n", '\n', 'contract Escrow{\n', '\n', '    using SafeMath for uint;\n', '    enum JobStatus { Open, inProgress, Completed, Cancelled }\n', '\n', '    struct Job{\n', '        string description;               // description of job\n', '        // uint JobID;                       // Id of the job\n', '        address manager;                  // address of manager\n', '        uint salaryDeposited;             // salary deposited by manager\n', '        address worker;                   // address of worker\n', '        JobStatus status;                 // current status of the job\n', '        uint noOfTotalPayments;           // total number of Payments set by the manager\n', '        uint noOfPaymentsMade;            // number of payments that have already been made\n', '        uint paymentAvailableForWorker;   // amount of DAI tokens available for the worker as claimable\n', '        uint totalPaidToWorker;           // total amount of DAI tokens paid to worker so far for this job\n', '        address evaluator;                // address of evaluator for this job\n', '        bool proofOfLastWorkVerified;     // status of the proof of work for the last milestone\n', '        uint sponsoredTokens;             // amount of DAI tokens sponsored to the job\n', '        mapping(address => uint) sponsors; // mapping of all the sponsors with their contributions for a job\n', '        address[] sponsorList;             // List of addresses for all sponsors for iterations\n', '        uint sponsorsCount;                // total number of contributors for this job\n', '    }\n', '\n', '    Job[] public Jobs;                    // List of all the jobs\n', '\n', '\n', '    mapping(address => uint[]) public JobsByManager;        // all the jobs held by a manager\n', '    mapping(address => uint[]) public JobsByWorker;         // all the jobs held by a worker\n', '\n', '\n', '    ERC20 public DAI;\n', '\n', '    uint public jobCount = 0;     // current count of the total Jobs\n', '\n', '    address public arbitrator;     // address of arbitrator\n', '\n', '    constructor(address _DAI, address _arbitrator) public{\n', '        DAI = ERC20(_DAI);\n', '        arbitrator = _arbitrator;\n', '    }\n', '\n', '    \n', '    modifier onlyArbitrator{\n', '        require(msg.sender == arbitrator);\n', '        _;\n', '    }\n', '\n', '    event JobCreated(address manager, uint salary, uint noOfTotalPayments, uint JobID, string description);\n', '\n', '    /// @notice this function creates a job\n', '    /// @dev Uses transferFrom on the DAI token contract\n', '    /// @param _salary is the amount of salary deposited by the manager\n', '    /// @param _noOfTotalPayments is the number of total payments iterations set by the manager\n', '    function createJob(string _description, uint _salary, uint _noOfTotalPayments) public {\n', '        require(_salary > 0);\n', '        require(_noOfTotalPayments > 0);\n', '\n', '        address[] memory empty;\n', '        uint finalSalary = _salary.sub(_salary.mul(1).div(50));\n', '\n', '        Job memory newJob = Job(_description, msg.sender, finalSalary, 0x0, JobStatus.Open, _noOfTotalPayments, 0, 0, 0, 0x0, false, 0, empty, 0);\n', '        Jobs.push(newJob);\n', '        JobsByManager[msg.sender].push(jobCount);\n', '\n', '        require(DAI.allowance(msg.sender, address(this)) >= _salary);\n', '\n', '        emit JobCreated(msg.sender, finalSalary, _noOfTotalPayments, jobCount, _description);\n', '        jobCount++;\n', '\n', '        DAI.transferFrom(msg.sender, address(this), _salary);  \n', '\n', '    }\n', '\n', '\n', '    event JobClaimed(address worker, uint JobID);\n', '\n', '    /// @notice this function lets the worker claim the job\n', '    /// @dev Uses transferFrom on the DAI token contract\n', '    /// @param _JobID is the ID of the job to be claimed by the worker\n', '    function claimJob(uint _JobID) public {\n', '        require(_JobID >= 0);\n', '\n', '        Job storage job = Jobs[_JobID];\n', '\n', '        require(msg.sender != job.manager);\n', '        require(msg.sender != job.evaluator);\n', '\n', '        require(job.status == JobStatus.Open);\n', '\n', '        job.worker = msg.sender;\n', '        job.status = JobStatus.inProgress;\n', '\n', '        JobsByWorker[msg.sender].push(_JobID);\n', '        emit JobClaimed(msg.sender, _JobID);\n', '\n', '        \n', '    }\n', '\n', '\n', '    event EvaluatorSet(uint JobID, address evaluator);\n', '\n', '    /// @notice this function lets a registered address become an evaluator for a job\n', '    /// @param _JobID is the ID of the job for which the sender wants to become an evaluator\n', '    function setEvaluator(uint _JobID) public {\n', '        require(_JobID >= 0);\n', '\n', '        Job storage job = Jobs[_JobID];\n', '\n', '        require(msg.sender != job.manager);\n', '        require(msg.sender != job.worker);\n', '\n', '        job.evaluator = msg.sender;\n', '        emit EvaluatorSet(_JobID, msg.sender);\n', '\n', '    }\n', '\n', '\n', '    event JobCancelled(uint JobID);\n', '\n', '    /// @notice this function lets the manager or arbitrator cancel the job\n', '    /// @dev Uses transfer on the DAI token contract to return DAI from escrow to manager\n', '    /// @param _JobID is the ID of the job to be cancelled\n', '    function cancelJob(uint _JobID) public {\n', '        require(_JobID >= 0);\n', '\n', '        Job storage job = Jobs[_JobID];\n', '\n', '        if(msg.sender != arbitrator){\n', '            require(job.manager == msg.sender);\n', '            require(job.worker == 0x0);\n', '            require(job.status == JobStatus.Open);\n', '        }\n', '\n', '        job.status = JobStatus.Cancelled;\n', '        uint returnAmount = job.salaryDeposited; \n', '\n', '        emit JobCancelled(_JobID);\n', '        DAI.transfer(job.manager, returnAmount);\n', '    }\n', '\n', '\n', '    event PaymentClaimed(address worker, uint amount, uint JobID);\n', '\n', '    /// @notice this function lets the worker claim the approved payment\n', '    /// @dev Uses transfer on the DAI token contract to send DAI from escrow to worker\n', '    /// @param _JobID is the ID of the job from which the worker intends to claim the DAI tokens\n', '    function claimPayment(uint _JobID) public {\n', '        require(_JobID >= 0);\n', '\n', '        Job storage job = Jobs[_JobID];\n', '\n', '        require(job.worker == msg.sender);\n', '\n', '        uint payment = job.paymentAvailableForWorker;\n', '        require(payment > 0);\n', '\n', '        job.paymentAvailableForWorker = 0;\n', '\n', '        emit PaymentClaimed(msg.sender, payment, _JobID);\n', '        DAI.transfer(msg.sender, payment);\n', '        \n', '    }\n', '\n', '\n', '    event PaymentApproved(address manager, uint JobID, uint amount);\n', '\n', '    /// @notice this function lets the manager to approve payment\n', '    /// @param _JobID is the ID of the job for which the payment is approved\n', '    function approvePayment(uint _JobID) public {\n', '        require(_JobID >= 0);\n', '\n', '        Job storage job = Jobs[_JobID];\n', '\n', '        if(msg.sender != arbitrator){\n', '            require(job.manager == msg.sender);\n', '            require(job.proofOfLastWorkVerified == true);\n', '        }\n', '        require(job.noOfTotalPayments > job.noOfPaymentsMade);\n', '\n', '        uint currentPayment = job.salaryDeposited.div(job.noOfTotalPayments);\n', '\n', '        job.paymentAvailableForWorker = job.paymentAvailableForWorker + currentPayment;\n', '        job.totalPaidToWorker = job.totalPaidToWorker + currentPayment;\n', '        job.noOfPaymentsMade++;\n', '\n', '        if(job.noOfTotalPayments == job.noOfPaymentsMade){\n', '            job.status = JobStatus.Completed;\n', '        }\n', '\n', '        emit PaymentApproved(msg.sender, _JobID, currentPayment);\n', '\n', '    }\n', '\n', '\n', '    event EvaluatorPaid(address manager, address evaluator, uint JobID, uint payment);\n', '\n', '    /// @notice this function lets the manager pay DAI to arbitrator\n', '    /// @dev Uses transferFrom on the DAI token contract to send DAI from manager to evaluator\n', '    /// @param _JobID is the ID of the job for which the evaluator is to be paid\n', '    /// @param _payment is the amount of DAI tokens to be paid to evaluator\n', '    function payToEvaluator(uint _JobID, uint _payment) public {\n', '        require(_JobID >= 0);\n', '        require(_payment > 0);\n', '\n', '        Job storage job = Jobs[_JobID];\n', '        require(msg.sender == job.manager);\n', '\n', '        address evaluator = job.evaluator;\n', '\n', '        require(DAI.allowance(job.manager, address(this)) >= _payment);\n', '\n', '        emit EvaluatorPaid(msg.sender, evaluator, _JobID, _payment);\n', '        DAI.transferFrom(job.manager, evaluator, _payment);\n', '\n', '\n', '    }\n', '\n', '\n', '    event ProofOfWorkConfirmed(uint JobID, address evaluator, bool proofVerified);\n', '\n', '    /// @notice this function lets the evaluator confirm the proof of work provided by worker \n', '    /// @param _JobID is the ID of the job for which the evaluator confirms proof of work\n', '    function confirmProofOfWork(uint _JobID) public {\n', '        require(_JobID >= 0);\n', '\n', '        Job storage job = Jobs[_JobID];\n', '        require(msg.sender == job.evaluator);\n', '\n', '        job.proofOfLastWorkVerified = true;\n', '\n', '        emit ProofOfWorkConfirmed(_JobID, job.evaluator, true);\n', '\n', '    }\n', '\n', '    event ProofOfWorkProvided(uint JobID, address worker, bool proofProvided);\n', '\n', '    /// @notice this function lets the worker provide proof of work\n', '    /// @param _JobID is the ID of the job for which worker provides proof\n', '    function provideProofOfWork(uint _JobID) public {\n', '        require(_JobID >= 0);\n', '\n', '        Job storage job = Jobs[_JobID];\n', '        require(msg.sender == job.worker);\n', '\n', '        job.proofOfLastWorkVerified = false;\n', '        emit ProofOfWorkProvided(_JobID, msg.sender, true);\n', '\n', '    }\n', '\n', '\n', '    event TipMade(address from, address to, uint amount);\n', '\n', '    /// @notice this function lets any registered address send DAI tokens to any other address\n', "    /// @dev Uses transferFrom on the DAI token contract to send DAI from sender's address to receiver's address\n", '    /// @param _to is the address of the receiver receiving the DAI tokens\n', '    /// @param _amount is the amount of DAI tokens to be paid to receiving address\n', '    function tip(address _to, uint _amount) public {\n', '        require(_to != 0x0);\n', '        require(_amount > 0);\n', '        require(DAI.allowance(msg.sender, address(this)) >= _amount);\n', '\n', '        emit TipMade(msg.sender, _to, _amount);\n', '        DAI.transferFrom(msg.sender, _to, _amount);\n', '    }\n', '\n', '\n', '    event DAISponsored(uint JobID, uint amount, address sponsor);\n', '    \n', '    /// @notice this function lets any registered address send DAI tokens to any Job as sponsored tokens\n', "    /// @dev Uses transferFrom on the DAI token contract to send DAI from sender's address to Escrow\n", '    /// @param _JobID is the ID of the job for which the sponsor contributes DAI\n', '    /// @param _amount is the amount of DAI tokens to be sponsored to the Job\n', '    function sponsorDAI(uint _JobID, uint _amount) public {\n', '        require(_JobID >= 0);\n', '        require(_amount > 0);\n', '\n', '        Job storage job = Jobs[_JobID];\n', '\n', '        if(job.sponsors[msg.sender] == 0){\n', '            job.sponsorList.push(msg.sender);\n', '        }\n', '\n', '        job.sponsors[msg.sender] = job.sponsors[msg.sender] + _amount;\n', '        job.sponsoredTokens = job.sponsoredTokens + _amount;\n', '\n', '        emit DAISponsored(_JobID, _amount, msg.sender);\n', '        \n', '        require(DAI.allowance(msg.sender, address(this)) >= _amount);\n', '        DAI.transferFrom(msg.sender, address(this), _amount);\n', '    }\n', '\n', '\n', '    event DAIWithdrawn(address receiver, uint amount);\n', '\n', '    /// @notice this function lets arbitrator withdraw DAI to the provided address \n', '    /// @dev Uses transfer on the DAI token contract to send DAI from Escrow to the provided address\n', '    /// @param _receiver is the receiving the withdrawn DAI tokens\n', '    /// @param _amount is the amount of DAI tokens to be withdrawn\n', '    function withdrawDAI(address _receiver, uint _amount) public onlyArbitrator {\n', '        require(_receiver != 0x0);\n', '        require(_amount > 0);\n', '        \n', '        require(DAI.balanceOf(address(this)) >= _amount);\n', '\n', '        DAI.transfer(_receiver, _amount);\n', '        emit DAIWithdrawn(_receiver, _amount);\n', '    }\n', '\n', '\n', '    /// @notice this function lets get an amount of sponsored DAI by an address in a given job\n', '    /// @param _JobID is the Job for the job\n', '    /// @param _sponsor is the address of sponsor for which we are retreiving the sponsored tokens amount\n', '    function get_Sponsored_Amount_in_Job_By_Address(uint _JobID, address _sponsor) public view returns (uint) {\n', '        require(_JobID >= 0);\n', '        require(_sponsor != 0x0);\n', '\n', '        Job storage job = Jobs[_JobID];\n', '\n', '        return job.sponsors[_sponsor];\n', '    }\n', '\n', '\n', '    /// @notice this function lets retreive the list of all sponsors in a given job\n', '    /// @param _JobID is the Job for the job for which we are retrieving the list of sponsors\n', '    function get_Sponsors_list_by_Job(uint _JobID) public view returns (address[] list) {\n', '        require(_JobID >= 0);\n', '\n', '        Job storage job = Jobs[_JobID];\n', '\n', '        list = new address[](job.sponsorsCount);\n', '\n', '        list = job.sponsorList;\n', '    }\n', '\n', '\n', '    function getJob(uint _JobID) public view returns ( string _description, address _manager, uint _salaryDeposited, address _worker, uint _status, uint _noOfTotalPayments, uint _noOfPaymentsMade, uint _paymentAvailableForWorker, uint _totalPaidToWorker, address _evaluator, bool _proofOfLastWorkVerified, uint _sponsoredTokens, uint _sponsorsCount) {\n', '        require(_JobID >= 0);\n', '\n', '        Job storage job = Jobs[_JobID];\n', '        _description = job.description;\n', '        _manager = job.manager;\n', '        _salaryDeposited = job.salaryDeposited;             \n', '        _worker = job.worker;                   \n', '        _status = uint(job.status);                 \n', '        _noOfTotalPayments = job.noOfTotalPayments;           \n', '        _noOfPaymentsMade = job.noOfPaymentsMade;           \n', '        _paymentAvailableForWorker = job.paymentAvailableForWorker;   \n', '        _totalPaidToWorker = job.totalPaidToWorker;           \n', '        _evaluator = job.evaluator;               \n', '        _proofOfLastWorkVerified = job.proofOfLastWorkVerified;     \n', '        _sponsoredTokens = job.sponsoredTokens;             \n', '        _sponsorsCount = job.sponsorsCount;\n', '    }\n', '\n', '}']