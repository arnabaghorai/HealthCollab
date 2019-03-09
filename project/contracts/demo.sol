pragma solidity ^0.5.0;
//pragma experimental ABIEncoderV2;
library SafeMath {

    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);// assert is similar as require
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        // uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return a / b;
    }

    /**
    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}

contract ERC20Basic {
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) public view returns (uint256);
    function transferFrom(address from, address to, uint256 value) public returns (bool);
    function approve(address spender, uint256 value) public returns (bool);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
contract Ownable {
    address public owner;


    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() public {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

}

contract BasicToken is ERC20Basic {
    using SafeMath for uint256;

    mapping(address => uint256) balances;

    uint256 totalSupply_;

    /**
    * @dev total number of tokens in existence
    */
    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    /**
    * @dev transfer token for a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));//
        require(_value <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;//returns true on success
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

}
contract StandardToken is ERC20, BasicToken {

    mapping (address => mapping (address => uint256)) internal allowed;


    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     *
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     */
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }

    /**
     * @dev Increase the amount of tokens that an owner allowed to a spender.
     *
     * approve should be called when allowed[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param _spender The address which will spend the funds.
     * @param _addedValue The amount of tokens to increase the allowance by.
     */
    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    /**
     * @dev Decrease the amount of tokens that an owner allowed to a spender.
     *
     * approve should be called when allowed[_spender] == 0. To decrement
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param _spender The address which will spend the funds.
     * @param _subtractedValue The amount of tokens to decrease the allowance by.
     */
    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

}
contract SpringToken is StandardToken, Ownable {

    string public constant name = "SpringToken"; // solium-disable-line uppercase
    string public constant symbol = "SPT"; // solium-disable-line uppercase
    uint8 public constant decimals = 18; // solium-disable-line uppercase

    uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(decimals));

    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
    constructor() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
        emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
    }
}
contract demo{
    address owner;
    uint constant public MAX_COUNT = 50;
    uint constant public MAX_PARAMETERS = 10;
    uint256 public tokenRewardAmount;
    address public tokenAddress;
    SpringToken public springToken;
    event HospitalAddition(address hospital);
    event Deposit(address indexed sender, uint256 value);
    event HospitalRemoval(address hospital);
    event PatientAddition(address patient);
    event PatientRemoval(address patient);
    event PatientRecordAdded(uint256 recordID, address patientAddress);
    event NameAddedToRecords(uint256 recordID, address patientAddress);
   // event PatientRecordAdded(uint256 recordID, address patientAddress);
 //   event NameAddedToRecords(uint256 recordID, address patientAddress);
    event TokenRewardSet(uint256 tokenReward);
    event PatientPaid(address patientAddress);
    struct Patient{
        bool providedName;
       // string name;
        uint id;
        address patient;
        address hospital;
        uint256 admissionDate;
        uint256 dischargeDate;
        uint256 visitReason;
        bytes32 passkey;
        uint256 count;
    }
    struct Hospital{
        address hospital;
        
        //string name;
        uint password;
    }
    struct symptoms{
        uint256[] parameters;
    }
    //struct dateRange {
        //uint256 admissionDate;
      //  uint256 dischargeDate;
    //}
    
    mapping (address => bool) public isPatient;
    uint no_hospitals=0;
//    mapping (uint256 => mapping (address => Patient)) records;
    mapping(address=>Patient) records;
    mapping (uint256 => dateRange) dateRanges;
    mapping (address => mapping (string => uint256)) mappingByName;
    uint256 public recordCount = 0;
    mapping (address => bool) public isHospital;
    mapping (address => symptoms) patientSymptoms;
    mapping (address => address) login;
    mapping (address => bytes32) passkeycheck;
    mapping (address => bytes32) passkeycheckhospital;
    mapping(address => mapping(uint256 => Patient)) recordmapping;
    mapping(address => mapping(uint256 => symptoms)) symptommapping;
    modifier hospitalDoesNotExist(address hospital) {
        require(!isHospital[hospital]);
        _;
    }
    struct dateRange {
        uint256 admissionDate;
        uint256 dischargeDate;
    }
    modifier hospitalExist(address hospital) {
        require(isHospital[hospital]);
        _;
    }
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    modifier countExceed(uint256 count,address _patientAddress){
        require(count <= records[_patientAddress].count);
        _;
    }
    //uint256 public tokenRewardAmount;
    //address public tokenAddress;
    modifier validParameters(uint count) {
        require(count <= MAX_COUNT && count != 0);
        _;
    }
     modifier patientDoesNotExist(address patient) {
        require(!isPatient[patient]);
        _;
    }

    modifier patientExist(address patient) {
        require(isPatient[patient]);
        _;
    }

    modifier notNull(address _address) {
        require(_address != address(0));
        _;
    }
    modifier higherThanZero(uint256 _uint) {
        require(_uint > 0);
        _;
    }
    
    //modifier notEmpty(string memory name) {
      //  bytes memory tempString = bytes(name);
        //require(tempString.length != 0);
        //_;
    //}

    modifier onlyPatient(uint256 recordId) {
        require(records[msg.sender].patient == msg.sender);
        _;
    }
    
    constructor(address _hospital,uint256 _password) public payable{//assuming initally there is only one hospital in network
        require(_hospital != address(0));
        owner = _hospital;
        isHospital[_hospital]=true;
        passkeycheck[_hospital] = getSHA((_password));
     //   login[_hospital]=_privatekey;
        //SpringToken s = new SpringToken();
        setSpringToken(address(new SpringToken()));
        uint256 initialReward = 1000;
        setSpringTokenReward(initialReward);
    }
    function addHospital(address _hospital,uint256 _password) public 
        onlyOwner
        hospitalDoesNotExist(_hospital)
        patientDoesNotExist(_hospital)
        notNull(_hospital){
        isHospital[_hospital] = true;
        passkeycheck[_hospital]= getSHA(_password);
       // login[_hospital]=_privatekey;
        //no_hospitals++;
        emit HospitalAddition(_hospital);
    }
    
    function removeHospital(address _hospital,uint256 _password)
        public
        onlyOwner
        hospitalExist(_hospital)
    {
        require((getSHA(_password))==passkeycheck[_hospital]);
        isHospital[_hospital] = false;
        login[_hospital]=address(0);
        emit HospitalRemoval(_hospital);
    }
    function addPatient(address _patient,uint256 _passkey)
        public
        onlyOwner
        patientDoesNotExist(_patient)
        hospitalDoesNotExist(_patient)
        notNull(_patient)
    {
        isPatient[_patient] = true;
        passkeycheck[_patient] = getSHA(_passkey);
        //passkeycheck[_patient]
        emit PatientAddition(_patient);
    }

    /// @dev Allows to remove a patient in the network.
    /// @param _patient Address of patient to remove.
    function removePatient(address _patient)
        public
        onlyOwner
        patientExist(_patient)
    {
        isPatient[_patient] = false;
        emit PatientRemoval(_patient);
    }
    
    /// @dev Allows to add a patient record in the network.
    /// @param _patientAddress address of the patient for record.
    /// @param _hospital address of the hospital for record.
    /// @param _admissionDate date of admission, simple uint.
    /// @param _dischargeDate date of discharge, simple uint.
    /// @param _visitReason internal code for reason for visit.
    function addRecord (
        //string memory _name,
        address _patientAddress,
        address _hospital,
        uint256 _admissionDate,
        uint256 _dischargeDate,
        uint256 _visitReason
        )
        public
        //onlyOwner
        patientExist(_patientAddress)
        hospitalExist(_hospital)
    {
       // records[_patientAddress].name = _name;
        records[_patientAddress].providedName = false;
        records[_patientAddress].patient = _patientAddress;
        records[_patientAddress].hospital = _hospital;
        records[_patientAddress].admissionDate = _admissionDate;
        records[_patientAddress].dischargeDate = _dischargeDate;
        records[_patientAddress].visitReason = _visitReason;
        records[_patientAddress].passkey = passkeycheck[_patientAddress];
        dateRanges[recordCount].admissionDate = _admissionDate;
        dateRanges[recordCount].dischargeDate = _dischargeDate;
        payPatient(_patientAddress);
        records[_patientAddress].count++;
        recordmapping[_patientAddress][records[_patientAddress].count] = records[_patientAddress];
        emit PatientRecordAdded(recordCount, _patientAddress);

        recordCount += 1;
    }
    function addSymptoms(uint256[] memory _parameters,address _patient,uint256 _count) public countExceed(_count,_patient){
        require(_parameters.length==10);
        patientSymptoms[_patient].parameters=_parameters;
        symptommapping[_patient][_count].parameters = _parameters;
        
    }
    function checkLogin(address _patientAddress,uint256 _number) public view returns (bool)
    {
        if((sha256(abi.encodePacked(_number)))==passkeycheck[_patientAddress]){
            return true;
        }
        else 
        {
            return false;
        }
    }
    function getRecord(address _patientAddress,uint256 _count)
        public
        //recordExists(_recordID, _patientAddress)
        //patientProvidedName(_recordID, _patientAddress)
        //onlyHospital(_recordID, _patientAddress)
        //hospitalExist()
        countExceed(_count,_patientAddress)
        view
        returns (
           // string memory _name,
            address _hospital,
            uint256 _admissionDate,
            uint256 _dischargeDate,
            uint256 _visitReason,
            uint256[] memory _symptoms
        )
    {   
        //require((getSHA(_password))==passkeycheck[_patientAddress]);
        
     //   _name = records[_patientAddress].name;
        _hospital = recordmapping[_patientAddress][_count].hospital;
        _admissionDate = recordmapping[_patientAddress][_count].admissionDate;
        _dischargeDate = recordmapping[_patientAddress][_count].dischargeDate;
        _visitReason = recordmapping[_patientAddress][_count].visitReason;
        _symptoms = symptommapping[_patientAddress][_count].parameters;
    }
    function getCurrentPatients(uint from, uint to)
        public
        hospitalExist(msg.sender)
        view
        returns (uint _numberOfPatients)
    {
        uint i;
        _numberOfPatients = 0;
        for(i = 0; i < recordCount; i++) {
            if(dateRanges[i].admissionDate >= from && dateRanges[i].dischargeDate <= to)
            _numberOfPatients += 1;
        }
    }
    function setSpringTokenReward(uint256 _tokenReward)
        public
        onlyOwner
        higherThanZero(_tokenReward)
    {
        tokenRewardAmount = _tokenReward;
        emit TokenRewardSet(_tokenReward);
    }

    /// @dev gets the balance of patient.
    /// @param _patientAddress address of patient.
    /// @return Returns patient balance.
    function getPatientBalance(address _patientAddress)
        public
        onlyOwner
        view
        returns (uint256)
    {
        return springToken.balanceOf(_patientAddress);
    }
    function getSHA(uint256 _pass) public pure returns (bytes32){
        bytes32 tp = sha256(abi.encodePacked(_pass));
        return tp;
    }
    /*
    * Internal functions
    */
    /// @dev sets the patient token reward contract.
    /// @param _newspringToken Address of patient token.
    function setSpringToken(address _newspringToken)
        internal
        onlyOwner
        notNull(_newspringToken)
    {
        springToken = SpringToken(_newspringToken);
        tokenAddress = address(springToken);
    }

    /// @dev pays a patient for providing their name.
    /// @param _patientAddress to receive tokens.
    function payPatient(address _patientAddress)
        private
        notNull(_patientAddress)
    {
        springToken.transfer(_patientAddress, tokenRewardAmount);
        emit PatientPaid(_patientAddress);
    }

}