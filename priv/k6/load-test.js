import http from "k6/http";
import { check, group, sleep, fail } from 'k6';

export const options = {
  stages: [{ target: 20, duration: '30s' }],
  thresholds: {
    'http_req_duration': ['p(95)<1000', 'p(99)<1500'],
    'http_req_duration{name:PublicEntitys}': ['avg<400'],
    'http_req_duration{name:Create}': ['avg<600', 'max<3000'],
  },
};

function randomString(length, charset = '') {
  if (!charset) charset = 'abcdefghijklmnopqrstuvwxyz';
  let res = '';
  while (length--) res += charset[(Math.random() * charset.length) | 0];
  return res;
}

const USERNAME = `${randomString(10)}`; // Set your own email or `${randomString(10)}@example.com`;
const PASSWORD = 'password21';
const BASE_URL = 'https://teste-debora-arvore.fly.dev';

export function setup() {
  // register a new user and authenticate via a Bearer token.
  const res = http.post(`${BASE_URL}/api/v1/accounts/users`, {
    name: 'Load Test',
    email: `${USERNAME}@email.com`,
    login: USERNAME,
    password: PASSWORD,
    type: 'admin'
  });

  check(res, { 'created user': (r) => r.status === 201 });

  const loginRes = http.post(`${BASE_URL}/api/v1/accounts/login`, {
    login: USERNAME,
    password: PASSWORD,
  });
  let login = loginRes.json('data');

  const authToken = login['jwt'];
  check(authToken, { 'logged in successfully': () => authToken !== '' });

  return authToken;
}

export default (authToken) => {
  const requestConfigWithTag = (tag) => ({
    headers: {
      Authorization: `Bearer ${authToken}`
    },
    tags: Object.assign(
      {},
      {
        name: 'PrivateEntitys',
      },
      tag
    ),
  });

  group('Public endpoints', () => {
    const responses = http.get('https://teste-debora-arvore.fly.dev/health');
  });

  group('Create and modify entities', () => {
    let URL = `${BASE_URL}/api/v2/partners/entities/`;

    group('Create entities', () => {
      const payload = {
        name: `Name ${randomString(10)}`,
        entity_type: 'network'
      };

      const res = http.post(URL, payload, requestConfigWithTag({ name: 'Create' }));

      if (check(res, { 'Entity created correctly': (r) => r.status === 201 })) {
        let create_data = res.json('data');

        let id = create_data['id'];
        URL = `${URL}${id}/`;
      } else {
        console.log(`Unable to create a Entity ${res.status} ${res.body}`);
        return;
      }
    });

    group('Update entity', () => {
      const payload = { name: `New name ${randomString(10)}` };
      const res = http.patch(URL, payload, requestConfigWithTag({ name: 'Update' }));
      const isSuccessfulUpdate = check(res, {
        'Update worked': () => res.status === 200
      });

      if (!isSuccessfulUpdate) {
        console.log(`Unable to update the entity ${res.status} ${res.body}`);
        return;
      }
    });
    const delRes = http.del(URL, null, requestConfigWithTag({ name: 'Delete' }));
    const isSuccessfulDelete = check(null, {
      'Entity was deleted correctly': () => delRes.status === 204,
    });

    if (!isSuccessfulDelete) {
      console.log(`Entity was not deleted properly`);
      return;
    }
  });

  sleep(1);
};