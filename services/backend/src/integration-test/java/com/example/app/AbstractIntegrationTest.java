@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@ActiveProfiles("it")
class UserFlowIT extends AbstractIntegrationTest {

  @Autowired
  TestRestTemplate restTemplate;

  @Test
  void shouldCreateAndFetchUser() {
    UserRequest request = new UserRequest("John", "john@mail.com");

    ResponseEntity<UserResponse> create =
        restTemplate.postForEntity("/api/users", request, UserResponse.class);

    assertThat(create.getStatusCode()).isEqualTo(HttpStatus.CREATED);

    ResponseEntity<UserResponse> get =
        restTemplate.getForEntity("/api/users/" + create.getBody().id(), UserResponse.class);

    assertThat(get.getBody().email()).isEqualTo("john@mail.com");
  }
}
